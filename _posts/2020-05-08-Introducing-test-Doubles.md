---
title: "A Complete Guide to Testing Your Software, Part 2: Introducing Test Doubles"
author: Alastair Smith
category: testing
tags:
 - testing
 - craft
 - TDD
 - mocks
 - stubs
 - fakes
 - spies
created: 1588946550
---

You might be familiar with the three wise monkeys, originating in a carving over a door of the Tōshō-gū shrine in Nikkō,
Japan. The monkeys are Mizaru (:see_no_evil:), who sees no evil; Kikazaru (:hear_no_evil:), who hears no evil; and
Iwazaru (:speak_no_evil:), who speaks no evil. Interesting to me, as person who thinks primarily visually, is that the
three wise monkeys themselves embody the maxim, rather than being only a representation of it. It also turns out they're
pretty useful as a touchpoint when considering the different forms of test doubles. Let's start by looking at what a
test double is, and what the different types of test double are.<!--break-->

## What is a Test Double anyway?

The term "Test Double" simply means [something replacing a production object in a test
scenario](https://www.martinfowler.com/bliki/TestDouble.html)\*, and gained wider acceptance thanks to Gerard Meszaros'
weighty tome _xUnit Test Patterns_. There are, of course, various ways in which an object can be used, and so we have
different terms for those different usages. 

**Fakes** are our Mizaru (:see_no_evil:), hiding evil from sight. Breaking dependencies on things that required a
database, network connection, random number generator, or any other source of unpredictability (evil) is imperative, and
fakes achieve this as hand-rolled test doubles. They should always be very simple and straightforward, containing little
to no behaviour, and definitely no branching logic. They are an excellent alternative to using a mocking library when
you find yourself replicating calls to the library across a number of tests. I also find them prefereable to using a
mocking library when replacing framework-specific types, such as `IUrlHelper` or `IHttpContext` in tests for ASP.NET
Core controllers.

**Stubs** are our Kikazaru (:hear_no_evil:). They provide canned responses for a dependency (including the ambient
environment, such as time), and in so doing mean that our tests will never hear any evil. 

**Mocks** and their sub-category **spies** are Iwazaru (:speak_no_evil:), ensuring our application never speaks any
evil. They check the unit under test is behaving the correct way, calling the right things, in the right order, with the
right arguments, and the correct number of times. They are for behaviour verification, such as:

 * Are we sending null values?
 * Are we providing a colour value greater than 255

I've described spies as a subcategory of mocks, as they achieve the same thing but in a different way. Mocks purport to
*replace* the dependency with a verifiable implementation, whilst spies *wrap* the original dependency to listen on
calls to the dependency and report back their findings.

## Care for your monkeys

Like all pets, our three wise monkeys need care and attention. There's a few rules of thumb we can use to ensure they
stay healthy and productive. 
 
### Stub queries, mock commands 

Command-Query Separation is a principle of object-oriented design. It proposes that all behaviour is either a Command or
a Query: Commands have side effects and return nothing, whilst Queries have no side effects and do return a value.
Separating these two types of operations encourages neater, more cohesive, system design. 

An example might be operations on a list: adding and removing items are Commands, whilst enumerating or retrieving items
are Queries. The side effects of the commands are the mutations of the list object. The primary benefit of Command-Query
Separation is in communication with other programmers, be they other members of your team, or yourself in six months'
time. Queries can be used anywhere with little consideration: they have no side effects and so can be invoked as needed.
Modifying state requires more thought. Using Command-Query Separation, we're able to communicate using nothing more than
the return type how much though 

We _could_ modify the state of the
list whilst enumerating it, but this would give us a ver different data structure (a stack or a queue), with a very
different contract (LIFO or FIFO). Mutating the state of the list whilst retrieving individual items would be little
different from a plain array.

### Don't mix these in a single test



### Don't use test doubles for things you don't own

\* Personally I'm not mad keen on the "stunt double" derivation of the term.  
