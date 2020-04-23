---
layout: post
title: Updates to Bob, v0.2 released!
author: alastairs
nid: 232
created: 1397304452
excerpt: !ruby/string:Sequel::SQL::Blob "Recently [I introduced a new library](http://codebork.com/2014/03/23/introducing-bob.html)
  to aid testing in C#, [Bob](https://github.com/alastairs/bobthebuilder). I've made
  a couple of updates to it recently, one small, and one a bit larger. The latest
  release tackles a few robustness issues and sees it move out of alpha phase and
  up to version 0.2!\r\n\r\n[Updated: 2014-04-12 16:00 GMT]"
---
Recently [I introduced a new library](http://codebork.com/2014/03/23/introducing-bob.html) to aid testing in C#, [Bob](https://github.com/alastairs/bobthebuilder). I've made a couple of updates to it recently, one small, and one a bit larger. The latest release tackles a few robustness issues and sees it move out of alpha phase and up to version 0.2!

# Support for Complex Types

The first new feature is support for complex types with parameterless constructors. You can now say `A.BuilderFor<Customer>().WithAddress(new Address())`, for example. As it turned out, Bob already supported this as, of course, types with parameterless constructors are easily constructed by the reflection API. There are now tests around this use case, however, so you can be sure it will continue to work!

# Support for Named Arguments syntax

The second new feature is a little larger: supporting a different syntax taking advantage of C# 4's support for named arguments. You can now say `A.BuilderFor<Customer>().With(customerId: 43)`, for example, and you can supply multiple properties to the same call, such as 

<pre>
A.BuilderFor&lt;Customer&gt;()
    .With(customerId: 43,
          givenName: "John",
          familyName: "Doe"
    ).Build();
</pre>

This might be useful if you have a set of properties that always travel together (and so might help you identify where a new class could be introduced). 

As before, you can skip the call to `Build()` if the compiler can work out that you're after an instance of the built type.

# Robustness

I've done a bit of redesign which threw up some places where the library wouldn't work quite as intended (e.g., see what happens if you call a builder method that doesn't start with the word 'With'). I now have a design I'm happier with, and have ironed out these peculiarities of functionality, and now feel that it should be more solid than previously. As such, I'm very happy to announce that I've removed the "alpha" tag from the package version and have bumped it to v0.2!

# Get Bob v0.2

All of these changes are available from NuGet in the 0.2 version of the package, just `install-package BobTheBuilder`!

Happy building!
