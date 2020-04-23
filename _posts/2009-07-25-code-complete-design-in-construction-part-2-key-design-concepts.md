---
layout: post
title: 'Code Complete: Design in Construction (Part 2 - Key Design Concepts)'
author: alastairs
nid: 97
created: 1248544800
excerpt: !ruby/string:Sequel::SQL::Blob "Design is essentially an exercise in managing
  complexity, and it is incredibly important to manage correctly.  Dijkstra (1989)
  stated that a single person working on a software development project needs to grapple
  with anything from one bit to a few hundred megabytes: this is 9 orders of magnitude.
  \ Given that software is always increasing in complexity, McConnell posits that
  this figure could be as much as 15 orders of magnitude or more today.  \r\n\r\nThis
  post covers in some depth the issues around managing complexity, ways to attach
  it, and the importance of doing so.  It will also cover desirable characteristics
  of design, and the different levels of design.  \r\n\r\n<strong>Note: this is a
  long post!</strong>\r\n"
---

Design is essentially an exercise in managing complexity, and it is incredibly important to manage correctly.  Dijkstra (1989) stated that a single person working on a software development project needs to grapple with anything from one bit to a few hundred megabytes: this is 9 orders of magnitude.  Given that software is always increasing in complexity, McConnell posits that this figure could be as much as 15 orders of magnitude or more today.  

Brooks (1987) describes complexity in terms of Aristotle's essential and accidental properties.  An essential property is something that must be there in order for the item to be classed as such; for example, a car must have an engine, wheels, and a cabin.  An accidental property, meanwhile, is something the item just happens to have; re-using the car example, it might have a V8 engine, 5 doors, and/or a convertible roof.  The accidental <em>difficulties</em> of programming were mostly solved some time ago, such as by moving from assembler to High-Level Languages such as Java and C#, or moving from batch operating systems to time-sharing operating systems.  There are many other examples.  The progress on the <em>essential</em> difficulties of programming, however, has been slower as might be expected: software development is a process of determining the details of a "highly-intricate, interlocking set of components", which arise from interfacing with the real world.  As such, the details can require exact correctness, etc.  Even with Domain-Specific Languages, programming is still hard.  As such, the root of all the essential difficulties in programming is complexity, both accidental and essential.

McConnell lists managing complexity as the single most important technical topic in software development, and goes on to refer to this task as software's Primary Technical Imperative.  Dijkstra (1989) stated that a single mind needs to grapple with anything from one bit to a few hundred megabytes: 9 orders of magnitude.  With software complexity closely following an exponential path, McConnell posits that this figure could realistically be 15 orders of magnitude or more today.  

The consequence of this statistic is that no one brain can store all the details of a modern computer program (Dijkstra, 1972).  Programs should therefore be organised in a way to allow us to safely focus on one bit at a time.  There are a number of techniques for achieving this, including:
<ul>
  <li>Using subsystems, loose coupling, modularisation, orthogonality, well-designed objects and packages...</li>
  <li>Keeping routines short</li>
  <li>Writing programs in terms of the problem domain (rather than the low-level implementation details)</li>
  <li>Working at the highest level of abstraction</li>
</ul>

Programmers who compensate for inherent human limitations write code that's easier for themselves and others to understand, and that has fewer errors.

Overly costly, and therefore ineffective, designs arise in three ways: either you have created a complex solution to simple problem; or you have coded a simple but incorrect solution to complex problem; or your solution is both inappropriate and complex for a non-trivial problem.  I reckon the last of these must be pretty terminal.  Re-visiting the Aristotelian definitions of complexity, you can see managing complexity as a two-stage process: minimizing the amount of essential complexity that has to be addressed at any one time, and preventing accidental complexity from needlessly proliferating.  These two activities will help you avoid the three classes of ineffective design.  

<a href="http://en.wikipedia.org/wiki/R._Buckminster_Fuller" title="Wikipedia article on Buckminster Fuller">R. Buckminster Fuller</a> famously said that,

<blockquote>"When I am working on a problem I never think about beauty.  I think only how to solve the problem.  But when I have finished, if the solution is not beautiful, I know it is wrong."</blockquote>

It's very easy to get hung up on trying to create an elegant or a beautiful design.  This is a little bit like trying to delicately paint the ears and stalks of wheat into a field before you've sketched out where the field will actually sit on the canvas.  That is to say, the beauty of the painting has more to do with the proportions of the different elements (golden ratios, etc.) than it does the individual elements.  If you sketch the painting well, it will be beautiful.  

McConnell lists the following "internal" characteristics of design; these he describes as inherent only to design, not other software-quality attributes.  
<ul>
  <li>Minimal complexity: no "clever" designs, just "simple" and "easy-to-understand".</li>  
  <li>Ease of maintenance: imagine the questions a maintenance programmer would ask about your code</li>
  <li>Loose coupling</li>
  <li>Extensibility</li>
  <li>Reusability</li>
  <li>High fan-in: have a high number of classes that use a given class. Implies it was designed to make good use of utility classes at lower levels.</li>
  <li>Low-to-medium fan-out: a given class uses a low-to-medium number of other classes.  High fan-out (>~7) indicates high complexity.</li>
  <li>Portability</li>
  <li>Leanness: has no extra parts. (Elegance?) A book is not finished when nothing more can be added, but when nothing more can be taken away (Voltaire).</li>
  <li>Stratification: Keep levels of decomposition stratified - view system at any level and get a consistent view (i.e., without dipping into other levels).  Open-Closed Principle?</li>
  <li>Standard techniques: e.g., patterns.</li>
</ul>

McConnell describes a number of levels of software design, ranging from an entire system right down to an individual routine.  The main problem encountered with the design of an entire system is that developers sometimes jump straight from here to class design.  This is obviously unwise, and can lead to some major issues down the line which might require heavy refactoring or a large design overhaul.  

The second level of design is that of subsystems, or packages; this can be expected to last a few weeks per subsystem.  After all major subsystems have been identified, the usage and communication scenarios between subsystems must be defined.  It is important to follow a couple of key heuristics here to achieve an elegant and loosely-coupled design.  For example, it is easier to be more restrictive at design-time and relax those restrictions later on that it is to try the other way around.  Erring on the side of simpler inter-system relations will help reduce coupling; calling a routine should be chosen over using a class, and the last resort should be to inherit a class.  Drawing a diagram of your communications flows will help you identify circular dependencies; the diagram should be acyclic to achieve maximum flexibility and efficiency.  Examples of common subsystems include business rules (laws, regulations, policies and procedures, etc.), the user interface, data access and system dependencies. Using the <abbr title="Model-View-Controller">MVC</abbr>, <abbr title="Model-View-Presenter">MVP</abbr> or <abbr title="Model-View-ViewModel">MVVM</abbr> can help achieve loose coupling between the UI and other subsystems, whilst an <abbr title="Object-Relational Mapper">ORM</abbr> or similar library helps to hide the implementation details of the database.  System dependencies should be isolated to maximise portability to other platforms. 

Class design is the third level, and can take anything up to a few days per class to complete.  All classes in the subsystem need to be identified and enumerated.  A database subsystem, for example, might be partitioned into a data access class, a persistence framework (which might have a number of classes), and metadata.  Class interactions must also be defined, and it's worth applying the <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#ISP">Interface Segregation</a> and <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#DIP">Dependency Inversion</a> principles here.  

Routine design is a natural successor to class design, as the interfaces defined in level 3 will declare some routines.  This fourth level defines the <em>private</em> routines on each class.  Often the process of completing this level of design results in a better understanding of the interface and so might cause knock-on changes in level 3.  You can expect to spend in the order of a few hours on each routine, and the responsibility falls to the individual programmer implementing the routine.  

The final level of design is that of each routine's internals.  This involves laying out the detailed functionality of the individual routines, and the responsibility again falls to the individual programmer.  Methods for achieving this can include writing pseudocode, looking up algorithms, or programming.  

<hr />
<h3>References</h3>
Brooks, F. P., Jr. (1987) "No Silver Bullets - Essence and Accidents of Software Engineering" <i>Computer</i>, <b>4</b> 10-19
Dijkstra, E. (1972) "The Humble Programmer." <i>Communications  of the ACM</i>. <b>15</b> 10 859-66
Dijkstra, E. (1989) "On the Cruelty of Really Teaching Computer Science." <i>Communications of the ACM</i>. <b>32</b> 12 1397-1414
