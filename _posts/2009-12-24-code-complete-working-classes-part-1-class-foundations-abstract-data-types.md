---
layout: post
title: 'Code Complete: Working Classes (Part 1 - Class Foundations: Abstract Data
  Types)'
author: alastairs
nid: 109
created: 1261656105
---
Another day, another <em>Code Complete</em> blog post.  I might even clear two today, looking at the number of notes I have for this one.  

The <a href="http://www.codebork.com/2009/09/29/design-practices.html" title="Code Complete: Design in Construction (Part 4 - Design Practices)">last post</a> rounded off the contribution to the discussion around the problems of designing software.  A new chapter means a new topic, and chapter 6, titled "Working Classes", deals with tips on, and the issues around, creating classes in your program.  First up is the topic of Abstract Data Types: what they are, why you should be interested, and how you should use them.
<!--break-->
An Abstract Data Type (ADT) is a collection of data and operations that work on that data.  As a result of this, ADTs allow you to work in the problem domain ("stock control system") rather than the implementation domain ("PHP and MySQL").  The use of ADTs provides a number of benefits:
<ul>
  <li>Hide implementation details</li>
  <li>Changes don't affect the whole program</li>
  <li>Make the interface more informative</li>
  <li>Easier to improve performance</li>
  <li>Program is more obviously correct</li>
  <li>Program becomes more self-documenting</li>
  <li>Don't have to pass data all over your program</li>
  <li>Able to work with real-world entities rather than with low-level implementation structures</li>
</ul>

ADTs can be defined from any system, be they relatively simple or highly complex.  For example, an ADT for a light would be very simple, with only two operations (switch on, switch off), and a private field for storing the current state of the light.  

McConnell provides a number of guidelines for defining ADTs.  First off, he suggests <strong>building low-level data types as ADTs, not from primitive data types</strong>; even simple items should be considered ADTs.  A list representing a set of billing records, for example, should be treated as a set of billing records, and not as a simple list.  Using the example of the light above, you might be tempted to dispense with the ADT and use a boolean value to indicate whether the light is on or off, reading and writing that boolean directly.  Using the ADT, however, improves the readability of your code, and improves its factoring: even using a boolean named <code>lightOn</code>, it is more intuitive to call <code>light.turnOn()</code> and <code>light.turnOff()</code> than it is to code <code>lightOn = true</code> and <code>lightOn = false</code>.  You also get the benefits of using the ADT, such as encapsulating the current state of the light and abstracting away the implementation details.  

The second tip is to <strong>treat common objects, such as files, as ADTs.</strong>  This is made quite simple by .NET and the JDK thanks to the various IO classes such as File, although this is less true of some of the scripting languages (ones dealing with file handles, such as Perl and PHP, spring to mind).  

Consider <strong>layering ADTs similar to the Operating System and/or the language abstractions.</strong>  For example, the OS doesn't make you position the read/write head at a specific phsyical address, and the language provides ADTs so you don't have to make tricky OS calls.  Endeavour to create your ADTs at a similar <em>or higher</em> level of abstraction, as is appropriate to the situation, and utilise layering to make your programming easier.  

Finally, <strong>ensure you refer to an ADT independently of the medium on which it's stored.</strong>  For example, you might be tempted to refer to a really large ADT as "Large ADT File", and have a Read() method.  This undoes the abstraction a bit and exposes more information than is needed.

<em>Exercise for the reader:</em> Using the above guidelines, see if you can define an ADT for a liquidiser (a blender for any American readers), an elevator, or a cruise control system.  

Of course, in non-OO languages such as C, you'll need to add in support for handling multiple instances of your ADT, such as self-rolled "constructors" and "destructors".  You will also likely need to introduce some kind of ID to distinguish between the different instances.  McConnell goes into more detail on this than I do here (I expect my readership is almost exclusively working in OO languages), so if you're interested in learning more, you will need to read the book!
