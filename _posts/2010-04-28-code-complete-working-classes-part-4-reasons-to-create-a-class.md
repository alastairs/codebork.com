---
layout: post
title: 'Code Complete: Working Classes (Part 4 - Reasons to Create a Class)'
author: alastairs
nid: 112
created: 1272490570
---
This fourth and final post in the mini-series on Working Classes covers the reasons to create a class.  These reasons are many and varied, but fall quite neatly into a number of groups.  These groups are: modelling concepts, managing complexity, hiding information, building for the future, and classes to avoid.  This post should be rather shorter than the recent ones, and hopefully more digestible as a result.  

I'm also experimenting with a new method of writing up my notes that I hope will make this post more coherent; I feel that some of my recent posts in the <em>Code Complete</em> series have been almost a sequence of short paragraphs and possibly haven't hung together too well.  I'm interested to know whether you think this post is an improvement, dear reader.
<!--break-->
<h3>Modelling Concepts</h3>
It is best practice to create a new class for each real-world or abstract object that you need to model in your application.  For example, if you model different forms of vehicle, create a separate class for each vehicle type, such as motorcycle, car, ambulance.  You can use an abstract vehicle class at the top of an inheritance hierarchy to model common properties such as registration plate.  Similarly, if you are modelling abstract objects, such as a shape, introduce a new class (and possible inheritance hierarchy) for this too, even though it doesn't exist in the real world.  

The <a href="http://www.codebork.com/2009/12/24/code-complete-working-classes-part-1-class-foundations-abstract-data-types.html" title="Code Complete: Working Classes (Part 1 - Class Foundations: Abstract Data Types)">earlier post on Abstract Data Types</a> provides more information on good ways to go about defining classes of this type.

<h3>Managing Complexity</h3>
New classes can help you manage your application's complexity in two ways: by reducing complexity, or by isolating it.  <strong>The single most important reason to create a class is to reduce complexity.</strong>  Classes allow you hide information so you won't need to think about it, which is a major win for reducing complexity in your application.  

Isolating complexity into a new class brings some benefits, too.  For example, errors are easier to spot if they are localised to one particular area, and it is easier to try several designs and keep the best one.  This allows you to experiment with different algorithms, or different implementations "under the hood", whilst keeping the interface the same.  

You should not be afraid to create a new class (but keep in mind the points about eliminating irrelevant classes below).  

[img_assist|nid=136|title=|desc=|link=none|align=center|width=400|height=297]

<h3>Hiding Information</h3>
As described in <a href="http://www.codebork.com/coding/2009/06/19/code-complete-design-construction-part-3-design-building-blocks-heuristics.html" title="Code Complete: Design in Construction (Part 3 - Design Building Blocks: Heuristics)">an earlier post on design</a>, information hiding is a powerful technique for managing complexity.  Create new classes to hide implementation details, limit the effects of changes you might make to an area of your system, and hide global data.  

Implementation details are best encapsulated in the routine or class hosting them; leaky abstractions bring implementation details to the fore, which then need to be managed carefully.  Create a new class to wall off certain implementation details.  

New classes can also be created to isolate the areas of your code likely to change.  Designing your application so that the areas most likely to change are the easiest to change will give you greater flexibility in future when the change comes along, and the effects of those changes can be mitigated through the design at the outset.  Maybe you expect a requirement to support multiple back-end databases (as is common with a number of web-based applications, for example); you would need to source or build yourself a database abstraction layer to ensure that the database system used was fully isolated from the rest of your application in order to prevent a large amount of re-work down the line.  

Some applications require global data or state to be maintained through the lifetime of an application (or HTTP request in a web application).  If this applies to your application, hide it behind a class interface; this affords you a number of benefits, such as allowing you to change the structure of your data without changing the program, and monitoring access to the data. Furthermore, and perhaps most importantly, <em>it makes you think about whether the data is truly global.</em>

<h3>Building for the Future</h3>
I'll admit this is a bit of a catch-all category for the remainder of McConnell's suggested reasons for creating a class.  They do seem to hang together under this heading, thought.  

You may want to introduce a new class to streamline parameter passing.  If you're passing lots of data around, then a different class organisation might work better.  This is one advantage of the <a href="http://en.wikipedia.org/wiki/MVVM" title="MVVM on Wikipedia">Model-View-ViewModel (MVVM)</a> pattern: into your view model class goes a bunch of related data and behaviour to be presented in your view, that perhaps doesn't form a coherent model of a concept (abstract or concrete).  For example, a ViewModel for the Facebook homepage might include your name, your news feed, your upcoming events, your suggestions, etc.; none of these would be in the "User" model, which would include your name, email address, gender, etc.  The ViewModel makes it much easier to pass around this collection of related data rather than passing each separate item as an individual parameter.  

If you need a central point of control for something, a pivot around which two components of the system revolve and interact, create a new class embodying that relationship.  For example, a class in this category might maintain knowledge of the number of entries in a table, or control of devices such as files, printers or database connections.  An example of this is the Repository pattern I have <a href="http://www.codebork.com/coding/2009/01/24/mocking-databases.html" title="Web Frameworks Evaluation II.iii: Mocking Database Connections in Unit Tests">previously covered</a>.  

[img_assist|nid=137|title=Actors Michael J. Fox and Christopher Lloyd in the movie Back to the Future.|desc=|link=none|align=center|width=399|height=268]

Classes are, of course, great for facilitating reusable code, which is something for which any good developer should be striving.  Code put into well-factored classes can be more easily re-used, so don't be afraid to refactor your code into new classes if appropriate (many refactoring patterns result in the creation of new classes).  McConnell also suggests moving code to its own class if it might be used in another program or module; approach this with some caution, however, particularly if you're in an environment adhering to the principle of <abbr title="You Ain't Gonna Need It">YAGNI</abbr>, as this might be considered a violation.  

New classes will help you plan for a family of programs.  This links back to the ideas listed in Information Hiding above: programs will change, so isolate the parts you expect to change by putting them into their own classes; your classes can then be modified without affecting the rest of the program.  Classes can also help you package related operations together, although you have the option of using packages/namespaces for a similar purpose if your language supports them.  

<h3>Classes to Avoid</h3>
So, if those are all the good reasons for creating a class, what sort of classes should you avoid creating?  What are <em>bad</em> reasons for creating a class?  

First up is the omniscient, all-knowing and all-powerful god class.  A good indicator of a god class is the use of a large number of accessors from another class, manipulating its data.  This is an indication that your class interfaces are not as strong as they might be.  

Irrelevant classes should be eliminated.  These are classes that are missing one of the two components of classes: behaviour or data.  If a class contains data, but no behaviour, consider moving the fields into other classes.  If the class does logically hang together as an entity, such as the classic property bag objects you occasionally find in an application of  the <abbr title="Model-View-Controller">MVC</abbr> pattern, you might want to consider converting them into structs if your language supports it and it is appropriate to your scenario.  Structs have different semantics in C# from classes: they are treated as value types rather than reference types.  

The other form of irrelevant class, those that contain behaviour but no data, are often named after verbs.  This is an anti-pattern: a class should model a concept, abstract or concrete, which by definition cannot be a verb and must be a noun.  The behaviour in classes such as these should be turned into a routine on another class.  

<h3>Conclusion</h3>
Well, that rounds off this post, and the mini series on Working Classes.  The next post will bring us on to Chapter 7 of <em>Code Complete</em>, which covers high quality routines.  I welcome any feedback you might have on this post, the mini-series, or on the <em>Code Complete</em> series as a whole; please leave me a comment or drop me an email.
