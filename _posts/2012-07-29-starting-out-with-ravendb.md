---
layout: post
title: Starting out with RavenDB
author: alastairs
nid: 213
created: 1343569208
---
A while back, I volunteered to re-do the [Cambridge Graduate Orchestra](http://www.cambridgegraduateorchestra.com/)'s website, to bring it up to date with the latest web techniques.  To provide persistence, I opted for [RavenDB](http://www.ravendb.net/), a "second-generation document database", as I had heard how good it was for rapid development and what a nice API it has.  These are my initial thoughts having wired it into my existing solution.  

<!--break-->

First off, RavenDB does have a very nice .NET API indeed.  I'm using it in embedded mode, which means nothing more than pulling down a different package off NuGet, and swapping out the instantiation of the standard `DocumentStore` class for an `EmbeddableDocumentStore` instance.  I also opted to customise the data storage directory.  The simplicity with which a connection can be made to Raven is best expressed through a sample:

[gist:3198273:Instantiate and initialise an EmbeddableDocumentStore.cs]

Once a document store has been initialised, you can then create sessions to talk to Raven.  Raven's session implementation follows the [Unit of Work pattern](http://www.martinfowler.com/eaaCatalog/unitOfWork.html) defined by Martin Fowler in his book Patterns of Enterprise Application Architecture.  This means that, within a session, the database is guaranteed to be consistent, and it is not until you call `SaveAllChanges()` at the end of your unit of work (if required) that the database is updated.  Again, working with Raven's session is trivial:

[gist:3198273:Complete a unit of work.cs]

So, the API is a joy to work with, and Raven's document model means you just don't have to worry about the database at all: you just throw your objects at Raven's API and they're persisted as-is.  There's none of that [Object-Relational impedance mismatch](https://en.wikipedia.org/wiki/Object-relational_impedance_mismatch) to get in the way.  

I do have one criticism of Raven so far, though.  Looking at the advice provided on [using Raven in an ASP.NET MVC app](http://ravendb.net/kb/3/using-ravendb-in-an-asp-net-mvc-website), we see a tight coupling of Raven to the controller: sessions are instantiated when an Action is executed by the MVC framework, and closed when the Action has finished being exectued.  Also take into account [Ayende's scorn](http://ayende.com/blog/3955/repository-is-the-new-singleton) for the [Repository pattern](http://www.martinfowler.com/eaaCatalog/repository.html), and the fact that trying to apply such a pattern with RavenDB [tends to cause more pain than that which it tries to solve](http://novuscraft.com/blog/ravendb-and-the-repository-pattern). This leaves us in a very difficult place from a unit testing perspective.  

[Phil Jones](http://orangelightning.co.uk/) [suggests](http://ravendb.net/kb/31/my-10-tips-and-tricks-with-ravendb) *not* abstracting RavenDB for unit testing purposes, and that

> Purists will argue these "unit tests" become "integration tests". I've not been bothered by "slowness".

I guess I am a "purist", then :-)  I agree that using an embedded in-memory database makes for some very fast integration tests, but *they are still integration tests*.  The point of unit testing is to be able to test a single unit of functionality **in isolation of the rest of the system**; Raven does not (easily) allow you to accomplish this.  The official advice, described above, ties the lifetime of Raven's session to that of the MVC framework, which means that the session object is not available from within a unit test without providing specific hooks in for the tests (a major no-no).  

A nicer alternative is to inject the `IDocumentStore`, or, better still, the `IDocumentSession` into the controller via its constructor, but this still couples the controller to Raven.  Both the `IDocumentStore` and the `IDocumentSession` can be cleanly configured using an IoC container provided it supports singleton and per-web request lifetime scopes.  Unfortunately, using this approach, and the unit testing best-practice of only mocking types that you own, you are left with an integration test: *you have to inject a real Raven object into the controllers*.  

The way to get around this - usually - is to wrap the third-party library in an abstraction.  In this particular situation, however, I will lose, or have to duplicate, much of the implementation of the Raven API to achieve this.  It seems a shame to have to sacrifice some of my hard-earned principles of good software development at this point to make use of such a great library and technology.  
