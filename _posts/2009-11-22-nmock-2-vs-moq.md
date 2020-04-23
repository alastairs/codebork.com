---
layout: post
title: NMock 2 vs Moq
author: alastairs
nid: 119
created: 1258895627
---
You may remember from <a href="http://www.codebork.com/coding/2008/08/24/nmock-framework.html" title="NMock Framework">my previous blog post on mocking frameworks</a> that I'm a bit of a fan of this kind of tool.  They're great for simplifying unit testing, and can also help guide you in to writing better, more loosely-coupled code via <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#DIP" title="Dependency Inversion Principle: one of the SOLID Principles of OOD">Dependency Injection</a>.  

Last night I spent some time porting some of my unit tests for a side project I'm working on from <a href="http://www.nmock.org/">NMock</a> 2 to <a href="http://code.google.com/p/moq/">Moq</a> 4 (currently in beta).  My reasons for switching were three-fold: first, NMock can only mock interfaces which was causing problems with testing some parts of my code that relied on elements of the ASP.NET MVC framework; second, NMock is unable to support some of the newer features of .NET as it was written to target .NET 2.0 (whilst each version of Moq is matched to the respective version of .NET, so the Moq 4 beta can utilise the C# 4.0 goodies like dynamic typing); last, the NMock project doesn't seem to be as active as it once was, with the last official build released in January 2008.  

As a result of this switch, I'm in more of a position to critically evaluate NMock and Moq than I was when I wrote my original post.  Here's a summary of my thoughts and experiences.
<!--break-->
Moq (which can be pronounced either as "Mock" or as "Mock-You") is a relatively new mocking framework on the scene, with v1.0 released in December 2007.  It has been designed specifically to integrate deeply with C# 3.0 and take advantage of the new language features in this version, such as implicit typing, lambda expressions and LINQ expression trees.  This enables you to create mock objects, assign them behaviours and record expectations about them in a simple way; it also means that you get full Intellisense support when creating your mock objects.  Moq's other advantage is that it eschews the Record/Replay syntax favoured by <a href="http://ayende.com/projects/rhino-mocks.aspx">Rhino Mocks</a>, which I find quite opaque and unintuitive.

NMock, whose last build was released in January 2008 (coincidence?), was originally started for .NET 1.0, and was updated for .NET 2.0 which shipped in ~2005.  It does not take advantage of the C# 3.0 language features, and so relies on a "fluent" syntax for creating stubs and recording expectations.  This makes reading the  expectations and stubs quite natural (the syntax is <em>very</em> close to English), but it is not the most natural way to program.  Additionally, there is no Intellisense support for the interfaces being mocked, as the framework relies quite a bit on magic strings.  

"Installing" Moq is really very simple: just download a zip file, extract it to some location, and reference Moq.dll (the only binary included) in your VS project.  The fact that it's completely contained within one binary makes it much simpler to manage the dependency on this framework in comparison with, say, <a href="https://www.hibernate.org/343.html" title="NHibernate homepage">NHibernate</a>: at only 285KB, it can be added to your project without bloating your project.  This all holds for NMock as well, of course.

The Moq paradigm is quite different from NMock's.  In NMock, you specify a local variable typed to your interface, and create a mock implementation (carried out by NMock via Reflection), as follows:

<blockcode language="csharp">
    Mockery mockFactory = new Mockery();
    var mockRepository = mockFactory.NewMock<IRepository>();
    var controller = new MyController(mockRepository);
</blockcode>

The advantage of this is that you can use your mock objects directly in your unit tests, provided you have written the code under test to adhere to the <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#DIP" title="Dependency Inversion Principle: one of the SOLID Principles of OOD">Dependency Inversion Principle</a>.  In Moq, the objects that you create are mocks, not implementations of your interface, so you have to do a smidgeon extra juggling to pass the mocked object around for use.  However, the power gained from this small sacrifice is quite immense: you can change the behaviour of mocks to be more "strict" (throwing an exception for any un-mocked members, as is the NMock behaviour); to act as "partial" mocks (i.e., calling into the base class's implementation for any un-mocked members); and more. Here's a simple example of how to create and use a mock object:

<blockcode language="csharp">
    Mock<IRepository> mockRepository = new Mock<IRepository>();
    var controller = new MyController(mockRepository.Object);
</blockcode>

Note how we have to use the <code language="csharp">Object</code> property on the mock object to access the actual mocked object.  

In NMock, you create stubs and expectations as follows:

<blockcode language="csharp">
    var id = 1;
    var user = new User { Username = "joebloggs", Role = "user" };
    Stub.On(mockRepository).Method("GetById").With(id).Will(Return.Value(user));
    Expect.Once.On(mockRepository).Method("SomeOtherMethod").WithNoArguments();
</blockcode>

Note the magic string indicating which method to stub, the similarity between the stub and the expectation, and the need to know of the internal workings of the GetById method.  If you don't record an expectation on a method and it is invoked on the mock object, an exception is thrown and your unit test fails.  These three things are NMock's greatest weaknesses, and it was only when I moved to Moq that I realised the importance of the second one.  

NMock conflates the ideas of a stub and an expectation, which can cause confusion for the developer.  According to the <a href="http://www.nmock.org/cheatsheet.html">NMock cheatsheet</a>, Stub is equivalent to Expect.AtLeast(0).  As a result, the API is not as clean as it might have been: stubs automatically create an expectation, and you create stub implementations when recording expectations.  

Moq clearly separates these ideas, and additionally removes the need for the mock factory (NMock's <code language="csharp">Mockery</code> class).  This allows a developer to get up and running with Moq more quickly than they might with NMock.  Handily, Moq does support the notion of a mock factory (via the cunningly-named <code language="csharp">MockFactory</code> class), which provides for creating many mocks with the same settings (i.e., "strict", "partial", etc.).  Creating a stub can be accomplished as follows:

<blockcode language="csharp">
    var id = 1;
    var user = new User { Username = "joebloggs", Role = "user" };
    mockRepository.Setup(repo => repo.GetById(id)).Returns(user);
</blockcode>

We can verify our expectations as follows:

<blockcode language="csharp">
    mockRepository.Verify(repo => repo.GetById(id), Times.Exactly(1));
</blockcode>

In both cases, the <code language="csharp">repo => repo.GetById(id)</code> syntax is a C# lambda expression.  Under the hood, this is a kind of anonymous delegate, and actually ends up creating the same IL as an anonymous delegate would.  This particular lambda is equivalent to the following method:

<blockcode>
    public User Anonymous(IRepository repo) {
        var id = 1;
        return repo.GetById(id);
    }
</blockcode>

It's important to note, however, that Moq uses lambdas to create expression trees to match on, and doesn't actually execute the lambda in the example above.  That is to say, Moq looks for method calls that match the pattern of "GetById on an object of type IRepository with argument of type int and value id".  

One hurdle I ran into when porting from NMock to Moq was an unhelpful and weird exception: my mocks were trying to convert objects of incompatible types, e.g., converting an int to a User object.  The reason for this is because I had created fake objects for use in my project, and was then referencing the property on the object in my lambda.  For example:

<blockcode language="csharp">
    var user = new User { Id = 1, Username = "joebloggs", Role = "user" };
    mockRepository.Setup(repo => repo.GetById(user.Id)).Returns(user);
</blockcode>

This messes up the expression tree matching that I mentioned above, so it's important to make sure you pass the right thing into your mock.  For example, the following code works as expected.  

<blockcode language="csharp">
    var userId = 1;
    var user = new User { Id = userId, Username = "joebloggs", Role = "user" };
    mockRepository.Setup(repo => repo.GetById(userId)).Returns(user);
</blockcode>

One annoyance is that if you want your stubbed method to return <code language="csharp">null</code>, you can't use the <code language="csharp">Returns()</code> method as simply as you'd like: a compiler error is thrown complaining about an ambiguity between the overloads of <code language="csharp">Returns()</code> and <code language="csharp">Returns<T>(Func<U>)</code>.  As such, you have to use a simple lambda expression as a parameter to the <code language="csharp">Returns()</code> method like so:

<blockcode language="csharp">
    mockRepository.Setup(repo => repo.GetById(userId)).Returns(() => null);
</blockcode>

The <code language="csharp">() => null</code> lambda is equivalent to the following method:

<blockcode language="csharp">
    public User Anonymous() {
        return null;
    }
</blockcode>

Other than this, however, Moq is a bit of a joy to use.  Because of the use of lambdas, you get Intellisense support on your own API (e.g., when typing out <code language="csharp">repo.GetById()</code>), which obviously speeds things up immensely.
