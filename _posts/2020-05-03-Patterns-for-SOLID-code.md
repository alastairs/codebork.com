---
title: "Patterns for SOLID code: Introduction"
author: Alastair Smith
category: design
tags:
 - craft
 - design
 - object-orientated programming
 - design patterns
 - SOLID principles
created: 1588534847
---

This is the first post in a new series I'm starting which discusses the Design Patterns I use, how, and why. The series
can and possibly should be considered a companion series to the [series on testing
software](https://codebork.com/2016/12/07/anatomy-of-a-unit-test.html).

I've [long described](https://www.slideshare.net/alastairs/dependency-injection-26362716) Design Patterns as the
"bricks and mortar" of software engineering, not so much in the sense that they make up the fabric of some
construction, but in the sense that they're fundamental. Some of the patterns, such as Iterator and Observer, have even
become language features, only one step away from programming primitives.

It's true to say that some of the patterns as [originally described by the Gang of Four (GoF)](https://amzn.to/3c1LCRx)
appear complicated when viewed with the context of programming languages in 2020, but to disregard them because of that
would most definitely be throwing the baby out with the bath water. A little adaptation makes them easier to implement
and remember, and I'll be sharing my revised implementations in this series.

But first, let's look at some examples of the Design Patterns in the real world.<!--break-->

## Program to the interface, not the implementation

"Program to the interface, not the implementation." "Favour composition over inheritance." These now classic pieces of
advice appear very early on in the original _Design Patterns_ text; you'll find them on pages 17-20. The GoF make the
case for these as fundamental principles of object-oriented software design succinctly and precisely, so won't cover
that here. Instead, I want to give a real-world example of the power and flexibility of compositional design: household
electicals.

![](/assets/images/decoupling-electricals.gif)

The above GIF describes a common household situation: a TV plugged into a wall. In the first frame of the GIF, the TV is
wired directly into the wall, a tight coupling in software terms. We aren't able to use the TV somewhere else without
moving the wall to that new place and all of the related circuitry, nor can we use a different electrical device such as
a standard lamp with that wall's electrical circuit. This is plainly absurd, but **this is how a lot of software is
built.** Domain logic is tied to the application's UI preventing it from being used in any other way, perhaps as a web
app or CLI tool. I once worked for a company that was forced to quote a potential customer a fee of £1m to allow the
product to run on the customer's existing relational database management system. The company somehow didn't lose the
customer (some markets are like that), but the customer had to shell out for SQL Server licences as well as Oracle
licences. Two of the most expensive pieces of software in the world, both doing the same thing, but supporting different
third-party products of which neither has any knowledge or interest. Seems pretty wasteful, right?

Household electrical circuits have solved this problem pretty neatly: they use an interface which all devices must
implement in order to be consumed. The remaining frames in the previous GIF illustrate the process, replacing the direct
coupling with a plug-and-socket pair (the shapes in blue), and then the benefit of doing so, unplugging the
TV and plugging in a laptop. This plug-and-socket interface maps neatly to the concept of an interface in software:
inserting the plug into the socket allows the electrical device to draw electricity from the supplier.

## Favour composition over inheritance

This is where the introduction of the interface becomes interesting, but first let's explore another patently-absurd
real-world scenario. We're going to add a surge protector to our TV, through the means of inheritance. Let's assume
we've already bought our surge protector component and have sufficient knowledge to attempt this. The GoF characterise
inheritance as **white-box reuse**:

> The term "white-box" refers to visibility: With inheritance, the internals of parent classes are often visible to
> subclasses.

So, treating our TV as a white box, we crack out the screwdrivers and set about removing the back panel of the TV. We
cut the electrical cable\*, strip the insultation from the ends and wire each into a different end of the surge
protector. Again, for those at the back: **this is how a lot of software is built.**

The interface-based approach, referred to as **black-box reuse** "because no internal details of objects are visible",
naturally leads us to a composition based approach. Our surge protector implements the same interface as the TV (the
plug-and-socket pair), so we simply plug the TV into the surge protector, and the surge protector into the mains socket,
and we've achieved the same outcome with fewer fires, electrical shocks, and trips to A&E. Not only that, but we can
also choose to remove the surge protector at any time, and still be able to use the TV.

This specific compositional approach, adding the surge-protection responsibility to the TV object, is a real-world
example of the **Decorator** pattern. Let's explore a couple of others quickly:

 * **Composite:** how do we gain additional sockets? Provide a collection of them with a 4-gang, power-strip, etc.
 * **Adapter:** how do we use an incompatible device, e.g. plugging a phone in to charge, or when visiting a foreign
   country? Provide an adapter to convert from one plug-and-socket interface to another.
 * **Visitor:** how do we ensure every device is working appropriately, without redefining the interface? Define a new
   operation (e.g., a [PAT test](https://www.pat.org.uk/pat-testing-regulations/)), and apply it to each device.
 * **Strategy:** which plug-and-socket pair is appropriate here? 3-pin mains; USB; HDMI?

### Conclusion: header interfaces vs role interfaces

The plug-and-socket pair is an excellent example of a role interface, [described by Martin
Fowler](https://www.martinfowler.com/bliki/RoleInterface.html) as defining "a specific interaction between suppliers
[the socket] and consumers [the plug]". It's probable that a "supplier component" will implement more than one role
interface: for example, a switch on the electrical socket plays a different role from the socket itelf.

A [header interface](https://www.martinfowler.com/bliki/HeaderInterface.html), meanwhile, is:

> &hellip; an explicit interface that mimics the implicit public interface of a class. Essentially you take
> all the public methods of a class and declare them in an interface. You can then supply an alternative implementation
> for the class.

Header interfaces are much easier to define, especially as they can be extracted quickly and automatically in many
modern IDEs and productivity tools. But they have a severe downside: breaking the [Interface Segregation Principle
(ISP)](https://en.wikipedia.org/wiki/Interface_segregation_principle). The ISP states that "no client should be forced
to depend on methods it does not use". Looking at the switch on the mains electrical socket and extracting a header
interface for that socket, defining both the electricity supply responsibility and the on/off switching responsibility,
means that the interface is no longer general purpose in the way the role interfaces were. We now need another interface
for HDMI, USB and other forms of unswitched plug-and-socket pairs\*\*, and we also need another interface for all the
things that can be switched that are not on the sockets' circuit (e.g. ceiling lights). Can you imagine what the world
would be like in such a scenario? Yes, it would be **exactly like it had been built by a software engineer.**

So, let's not say "yes" to header interfaces because they're easy, and let's not say "no" to role interfaces because
they're hard. Let's choose a world of role interfaces, [because that goal will serve to organize and measure the
best of our energies and skills](https://er.jsc.nasa.gov/seh/ricetalk.htm).

\* Remember it's still wired directly into the mains!

\*\* And, of course, unswitched mains plug-and-socket pairs in the UK as well as elsewhere&hellip;
