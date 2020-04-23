---
layout: post
title: Introducing Bob
author: alastairs
nid: 231
created: 1395602448
excerpt: !ruby/string:Sequel::SQL::Blob "Test Data Builders are awesome and you should
  use them to tidy up your test code (read about them in GOOS Chapter 22). I'm introducing
  a new library called [Bob](http://github.com/alastairs/BobTheBuilder) which replaces
  the need to write your own hand-rolled Test Data Builders with a generic solution
  that preserves the fluent syntax suggested by GOOS. \r\n"
---
## TL;DR

Test Data Builders are awesome and you should use them to tidy up your test code (read about them in GOOS Chapter 22). I'm introducing a new library called [Bob](http://github.com/alastairs/BobTheBuilder) which replaces the need to write your own hand-rolled Test Data Builders with a generic solution that preserves the fluent syntax suggested by GOOS. 

## Test Data Builders

One of the most influential books on software development practice in recent years is *Growing Object Oriented Software, Guided by Tests*, or GOOS for short. It describes an approach to application development based on Test-Driven Development, but demonstrates how to effectively use Mocks, Stubs and Fakes to drive your application's design from the outside and model it around the communications between collaborators, rather than stored state. 

A key recommendation GOOS makes for keeping your test code clean is to use a technique called Test Data Builders (Chapter 22, p257). This approach leans on the Builder pattern from the Gang of Four (GoF) to abstract away the construction of objects on which your tests depend, but do not necessarily care about. For example, say you are developing an online shop, which models customers and orders. You might write your tests like this:

    [Fact]
    public void Placing_An_Order_Adds_The_Order_To_The_Customers_Account()
    {
        // Arrange
        var customer = new Customer(1, // Id
                                    "Joe", "Bloggs", // Name
                                    "10 City Road", "Staines", "Middlesex", "AB1 2CD" // Address
                                    );
        var order = new Order(1, customer);

        // Act, Assert: not interesting for this example
    }

After a while and a couple of tests, you realise you've got some duplicated code that you could factor out, so you introduce a couple of factory methods. Maybe you even include default parameter values to allow you to reuse the same factory method:

    [Fact]
    public void Placing_An_Order_Adds_The_Order_To_The_Customers_Account()
    {
        // Arrange
        var customer = CreateCustomer();
        var order = new Order(1, customer);

        // ...
    }

    private Customer CreateCustomer(int id = 1,
                                    string givenName = "Joe",
                                    string familyName = "Bloggs",
                                    string addressLine1 = "10 City Road",
                                    string addressLine2 = "Staines",
                                    string county = "Middlesex",
                                    string postCode = "AB1 2CD") 
    {
        return new Customer(id, givenName, familyName, addressLine1, AddressLine2, county, postCode);
    }

    private Order CreateOrder(Customer customer, int id = 1)
    {
        return new Order(id, customer);
    }

But time goes on, and you find this approach isn't really working for you either. Perhaps you have somehow ended up with three versions of `CreateCustomer()` that take different dependencies, or some abstraction is leaking all over your tests in spite of your best efforts. This is where the Test Data Builder pattern comes in. 

The Test Data Builder pattern is really just an implementation of the Builder pattern from GoF. This is a creational pattern, like the more common Factory Method and Abstract Factory patterns, and while it is more complicated than either factory pattern, it provides more flexibility too. It achieves this by separating the construction of the object from the object's representation. As defined in GoF, it is a fairly complex pattern, but GOOS simplifies it somewhat. 

We start by defining a Builder class for the type we need to construct, which defines a Build() method returning the type we need:

    internal class CustomerBuilder
    {
        public Customer Build()
        {
            return new Customer(1, // Id
                                "Joe", "Bloggs", // Name
                                "10 City Road", "Staines", "Middlesex", "AB1 2CD" // Address
                                    );
        }
    }

So far, so uninteresting. Next we start adding methods to define how we want the built `Customer` to look:

    internal class CustomerBuilder
    {
        private string givenName;
        private string familyName;

        public CustomerBuilder WithGivenName(string newGivenName)
        {
            givenName = newGivenName;
            return this;
        }

        public CustomerBuilder WithFamilyName(string newFamilyName)
        {
            familyName = newFamilyName;
            return this;
        }

        public Customer Build()
        {
            return new Customer(1, // Id
                                givenName, familyName
                                "10 City Road", "Staines", "Middlesex", "AB1 2CD" // Address
                                );

        }
    }

There are two things to notice from the above code sample. First, we get to remove those pesky comments because the code now better reveals its intent: it is self-documenting, which is the dream. 

The second thing to notice is the builder methods return the current instance of `CustomerBuilder`. This allows us to chain calls to the builder methods together to form a nice fluent interface:

    [Fact]
    public void Placing_An_Order_Adds_The_Order_To_The_Customers_Account()
    {
        // Arrange
        var customer = new CustomerBuilder()
                               .WithGivenName("Joe")
                               .WithFamilyName("Bloggs")
                               .Build();
        var order = new Order(1, customer);

        // ...
    }

Much nicer! This can be combined with a Factory Method in your test fixture to create the `CustomerBuilder`, which can make the code fully fluent:

    [Fact]
    public void Placing_An_Order_Adds_The_Order_To_The_Customers_Account()
    {
        // Arrange
        var customer = ACustomer()
                           .WithGivenName("Joe")
                           .WithFamilyName("Bloggs")
                           .Build();
        // ...
    }

    private CustomerBuilder ACustomer()
    {
        return new CustomerBuilder();
    }


Furthermore, you can add methods to your Builder along the lines of `WithNoFamilyName()` to make explicit situations where that part of the object should not be set. For example an Address object will have optional information such as `AddressLine2`, or you may wish to test what happens when no post code is provided as part of the address.

[Mark Seemann](http://blog.ploeh.dk/) proposed a couple of extensions to the original GOOS Test Data Builder, which are quite nice. The first is to use the constructor of the Builder to define any default values that must be provided to the object being built. The second is to define an implicit cast from the Builder to the built type, to eliminate the noise of explicitly calling `Build()` all over the place:

    internal class CustomerBuilder
    {
        // ...

        public static implicit operator Customer(CustomerBuilder builder)
        {
            return builder.Build();
        }
    }

## Introducing Bob

I've been writing Test Data Builders for a good number of months now, and as useful as the pattern is I find myself feeling frustrated at the amount of boilerplate code it demands: the builder methods in particular are quite annoying as they are so similar. I started off by trying to reduce the amount of typing I had to do by using [ReSharper](http://www.jetbrains.com/resharper) templates to stub out the different facets of the pattern such as the builder class, the builder methods, etc., but then I moved jobs and lost them all. I haven't yet got around to reproducing the templates in my new dev environment. 

Then a couple of days ago I had an idea. [Simple.Data](http://github.com/markrendle/Simple.Data) uses the Dynamic Language Runtime and the dynamic dispatch features of C# to offer methods  that represent columns in your database tables (e.g. `pets.FindById(256);`, `pets.FindByType("Dog");`, etc.). Perhaps the Test Data Builder pattern implementation can be generalised using the techniques? 

I spent today spiking a new library to do this, [Bob](http://github.com/alastairs/BobTheBuilder). You use it like this:

    [Fact]
    public void Placing_An_Order_Adds_The_Order_To_The_Customers_Account()
    {
        // Arrange
        var customer = A.BuilderFor<Customer>()
                           .WithGivenName("Joe")
                           .WithFamilyName("Bloggs")
                           .Build();
        // ...
    }

It also implements Mark's second extension to the pattern, whereby you can implicitly cast from the Builder returned by `BuilderFor<T>()` to `T` and have it invoke the `Build()` method to complete the conversion.

It is, admittedly pretty limited in functionality at the moment because it's a proof of concept. It will only build instances of types that have a default (i.e. parameterless) constructor and that provide public setters on properties for the things that are to be set. I will build out the functionality as I need it, and [I have published a Task list](https://github.com/alastairs/BobTheBuilder/#task-list) of immediately-forthcoming functionality. 

Check it out and let me know what you think!
