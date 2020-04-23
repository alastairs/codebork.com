---
layout: post
title: 'Code Complete: Working Classes (Part 2 - Good Class Interfaces)'
author: alastairs
nid: 110
created: 1261683197
---
This post represents the second instalment taken from chapter 6 of <em>Code Complete</em>, entitled "Working Classes".  This post covers the issues to consider when designing class interfaces, illustrated with code samples.  An important piece of information to keep in mind when reading this post is that McConnell is talking in terms of the public interface exposed by a <em>class</em> through its public members.  While an interface (as defined in Java or C#) also fits this bill, some of the advice given here is specific to the idea of a class interface, and not a standalone interface.

If you're after the executive summary (this is quite a long post, after all), there are only two things you must build into your class interfaces: <strong>good abstraction and good encapsulation.</strong>  Read on to find out more.
<!--break-->
<h2>Good Abstraction</h2>

A good abstraction is one that is self-consistent, programmatic and clearly-defined.  As such, <strong>a class's interface should offer a group of routines that clearly belong together.</strong>  For example, an <code>Employee</code> class should describe an employee's personal details and provide services to initialise and use an <code>Employee</code> object.  Listing 1 below provides an example of a class interface with good abstraction, while Listing 2 provides an example poor abstraction.  
<blockcode language="csharp">
public class Employee {
    public string Name { get; set; }
    public string Address { get; set; }
    public string HomePhoneNumber { get; set; }
    public string WorkPhoneNumber { get; set; }
    public TaxId TaxId { get; set; }
    public JobClassification JobClassification { get; set; }               

    public Employee() { }

    public Employee(string name, string address,
                    string homePhone, string workPhone,
                    TaxId taxId, JobClassification jobClass) {
        Name = name;
        Address = address;
        HomePhoneNumber = homePhone;
        WorkPhoneNumber = workPhone;
        TaxId = taxId;
        JobClassification = jobClass;
    }
}
</blockcode>
<span class="inline inline-center caption"><strong>Listing 1:</strong> A Class Interface with Good Abstraction</span>

Internally of course the class may have additional routines, data, etc. to support the publicly-available methods and data, but the user of the class doesn't need to care or even know about these.  Compare this with the following class interface providing a poor abstraction; there is so much wrong with this, McConnell awards it a Coding Horror badge:

<blockcode language="csharp">
public class Program {
    public void InitialiseCommandStack();
    public void PushCommand(Command command);
    public Command PopCommand();
    public void InitialiseReportFormatting();
    public void FormatReport(Report report);              

    // ... etc.
}
</blockcode>
<span class="inline inline-center caption"><strong>Listing 2:</strong> A Class Interface with Bad Abstraction</span>

To improve Listing 2, the routines should be refactored into separate classes, and the <code>Program</code> class should have a consistent abstraction with high cohesion, such as in Listing 3:

<blockcode language="csharp">
public class Program {
    public void InitialiseUserInterface();
    public void ShutdownUserInterface();
    public void InitialiseReports();
    public void ShutdownReports();               

    // ... etc.
}
</blockcode>
<span class="inline inline-center caption"><strong>Listing 3:</strong> A Class Interface with Better Abstraction</span>

An extension to this idea is to use the <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#SRP" title="SOLID Principles of OOD: Single Responsibility Principle">Single Responsibility Principle (SRP)</a>, which ensures each class has internal cohesion in addition to good interface cohesion.  

<strong>The class interface should present a consistent level of abstraction.</strong>  For example, each class should implement one and only one <a href="http://www.codebork.com/2009/12/24/code-complete-working-classes-part-1-class-foundations-abstract-data-types.html" title="Code Complete: Work Classes (Part 1 - Class Foundations: Abstract Data Types)">Abstract Data Type</a>.  Mixing levels of abstraction in a class, such as providing methods to read a file and process the data read in, is poor design: it reduces cohesion, weakens the class's own abstraction, increases coupling, and results in a maintenance nightmare.  

When coding your class, <strong>be sure you understand what abstraction the class is implementing.</strong>  McConnell relays the anecdote of a project he once worked on that ended up wrapping a spreadsheet control rather than a simpler grid control, because the spreadsheet abstraction was closer to what the control needed to do.  The wrapper class exposed all <em>n</em>-hundred methods of spreadsheet, rather than simplifying to the needed grid plus <em>n</em> methods required to implement the same functionality "super-grid" functionality.  There was uproar at implementation time, but it proved to be the correct decision when it came to maintenance: the spreadsheet abstraction was a stronger one for the control, which meant the implementation was simpler to grasp than the equivalent grid implementation would have been.  

<strong>Ensure that your class's services are provided in pairs with their opposites.</strong>  As an example, if your class has an operation adding an item to a list, it will likely need one removing an item from the list as well.  Don't create these pairs willy-nilly, but do always check to see if you need the complementary operation when you create one.  

Don't be afraid to <strong>move unrelated information to another class.</strong>  (Again, this reflects on the SRP.)  Occasionally you will come across a situation where half the class's routines work with one half of the data, whilst the other half of the routines work with the other half of the data.  In situations like this, you should split the two halves into separate classes that have their own cohesive and consistent abstractions.  

<strong>Interfaces should be programmatic rather than semantic.</strong>  McConnell describes how an interface definition conceptually consists of two parts.  The <em>programmatic</em> part consists of the data types and other attributes that can be enforced by the compiler, whilst the <em>semantic</em> part is made from the assumptions of how the interface will be used (such as "<code>MethodA()</code> must be called before <code>MethodB()</code>").  This semantic part should be documented in the class/file comments, but <strong>it is important to keep interfaces only minimally dependent on documentation</strong>: often documentation goes unread, and comments tend to fall out of sync with the code they document.  A nifty trick is to use asserts or other similar techniques to make the semantic elements of the interface programmatic.

Speaking of changing code, you should <strong>beware of erosion of the interface's abstraction under modification.</strong>  Listing 4 provides an example of a class that has been modified without giving thought to the interface abstraction:

<blockcode language="csharp">
public class Employee {
    public FullName FullName { get; set; }
    public Address Address { get; set; }
    public PhoneNumber WorkPhoneNumber { get; set; }

    // ...

    public bool IsJobClassificationValid(JobClassification jobClass) {
        // ...
    }

    public bool IsPostCodeValid(Address address) {
        // ...
    }

    public bool IsPhoneNumberValid(PhoneNumber phoneNumber) {
        // ...
    }

    public SQLQuery CreateNewEmployeeQuery { get; }
    public SQLQuery ModifyEmployeeQuery { get; }
    public SQLQuery RetrieveEmployeeQuery { get; }
}
</blockcode>
<span class="inline inline-center caption"><strong>Listing 4:</strong> Example of a Class Interface that's Eroding Under Maintenance</span>

In the real world, there is no logical connection between employees and routines that check valid post codes, etc. &mdash; unless of course you're employing people to manually validate post codes!  I think we can agree that's sufficiently unlikely.  Similarly, the database interaction methods do not belong here, because they are at a much lower level of abstraction than the employee class itself.  Utilising an <abbr title="Object-Relational Mapping">ORM</abbr> library like NHibernate<sup>*</sup> allows you to create an <code>Employee</code> from the database, abstracting away the mechanics of talking to the database.  

<strong>Don't add public members that are inconsistent with the interface abstraction!</strong>  Always ask yourself whether the member you are adding is consistent with the class's abstraction.  If it's not, find a better place to put it, creating a new class if necessary.  

It is important to <strong>consider abstraction and cohesion together.</strong>  These ideas are closely related: a class interface that presents a good abstraction usually has strong cohesion, although the inverse doesn't hold as strongly.  If you see a class that has weak cohesion and you can't work out how to correct it, ask yourself whether the class presents a good abstraction.

<h2>Good Encapsulation</h2>
As we saw in a previous post, <a href="http://www.codebork.com/coding/2009/06/19/code-complete-design-construction-part-3-design-building-blocks-heuristics.html" title="Code Complete: Design in Construction (Part 3 - Design Building Blocks: Heuristics)">encapsulation is a stronger concept than abstraction</a>.  Whilst abstraction helps manage complexity, encapsulation enforces the abstraction by preventing you from looking at the details.  McConnell takes no prisoners in pairing these together: <strong>either you have both abstraction and encapsulation or you have neither.  There is no middle ground.</strong>

So, how do we practice good encapsulation?  First off, we must <strong>minimise the accessibility of classes and their members.</strong>  Good object-oriented languages provide differing levels of accessibility, including <code>public</code>, <code>protected</code> and <code>private</code>.  .NET also provides two further access modifiers: <code>internal</code> (accessible by other members of the same assembly), and <code>protected internal</code> (accessible by other members of the same assembly, or derived classes in another assembly).  You should know the definitions of each of these accessibility levels inside out, so that you can fully grasp the implications of using each.  

One school of thought in utilising access modifiers is to lock down the class or member to the lowest workable level; however, this is not necessary if exposure is consistent with the abstraction.  It's worth keeping in mind that <em>hiding more is generally better than hiding less.</em>  Certainly you should <strong>never expose member data in public:</strong> this violates encapsulation in perhaps the most heinous way.  

McConnell also warns against putting private implementation details into a class's interface.  In modern languages like C# and Java, this isn't possible, and may in fact be specific only to languages where private implementation details can be exposed via the class's header file (e.g., C++ and Objective-C).  

When designing and implementing your classes, you should <strong>avoid making assumptions about the class's users.</strong>  Instead you should design and code to adhere to the contract specified by the class's interface.  You should also <strong>avoid friend classes</strong>.  These are classes that know about the internals of their friends.  Again, they violate encapsulation, and expand the amount of code you have to think about at any one time, increasing complexity.  They can very infrequently be used to manage complexity, such as in the <a href="http://en.wikipedia.org/wiki/State_pattern" title="State pattern - Wikipedia, the free encyclopedia">State pattern</a>.

<strong>Don't put a routine into the public interface just because it uses only public routines.</strong>  The fact that only public routines are used by a routine is irrelevant to whether it should be exposed in the interface.  If it's not consistent with the abstraction, don't expose it.

You should also <strong>favour read-time convenience to write-time convenience.</strong>  This was also touched on in <em>The Pragmatic Programmer</em>.  Source code is read many, many, many more times than it is written; favouring write-time convenience is a false economy.  

<strong>Be wary of semantic violations of encapsulation.</strong>  Semantic violations can be quite difficult to spot, so here's a run-down of some examples:
<ul>
  <li>Not calling <code>ClassA</code>'s <code>Initialise()</code> method because you know that <code>ClassA.PerformFirstOperation()</code> calls it automatically</li>
  <li>Not calling <code>database.Connect()</code> before calling <code>employee.Retrieve(database)</code> because you know <code>Retrieve()</code> will automatically connect to the database if there isn't already a connection</li>
  <li>Not calling <code>ClassA.Terminate()</code> because you know <code>ClassA.PerformFinalOperation()</code> calls it automatically</li>
  <li>Using a reference to <code>ObjectB</code> created by <code>ObjectA</code> even after <code>ObjectA</code> has gone out of scope because you know <code>ObjectA</code> keeps <code>ObjectB</code> in static storage and <code>ObjectB</code> will still be valid.  This to me sounds like a great route to creating memory leaks.</li>
  <li>Using <code>ClassB.MAXIMUM_ELEMENTS</code> constant instead of using <code>ClassA.MAXIMUM_ELEMENTS</code> constant because you know they're both set to the same value.</li>
</ul>

The problem with semantic violations of encapsulation is that they make the client code depend on the private implementations, not the public interface.  What happens if, in the last example above, the value of <code>ClassB.MAXIMUM_ELEMENTS</code> changes?  At best, you will notice an obvious bug, but more likely some subtle behaviour will have been introduced into the application that will be hard to reproduce.  

Always <strong>watch for coupling that is too tight.</strong>  Ensure you minimise the accessibility of your classes and their members, and avoid friend classes because they're tightly coupled (by definition).  Make data private rather than protected in a base class so that derived classes are less tightly coupled to the base class.

Finally, be sure to <strong>observe the <a href="http://en.wikipedia.org/wiki/Law_Of_Demeter" title="Law of Demeter - Wikipedia, the free encyclopedia">Law of Demeter</a></strong>, also referred to as the Principle of Least Knowledge.  This is succinctly defined as 

<blockquote cite="http://en.wikipedia.org/wiki/Law_Of_Demeter">
Each unit should have only limited knowledge about other units: only units "closely" related to the current unit.
</blockquote>

Any given class should make as few assumptions as possible in its communications with other entities.  Formally, for any method <em>M</em> on object <em>O</em>, <em>M</em> may reference:
<ul>
  <li><em>O</em></li>
  <li><em>M</em>'s parameters</li>
  <li>anything created within <em>M</em></li>
  <li>any direct component of <em>O</em></li>
  <li>global variables accessible by <em>O</em> in the scope of <em>M</em></li>
</ul>

The result of these restrictions is that your code should only use one dot.  For example <code>a.Method()</code> obeys the rule, but <code>a.nother.Method()</code> violates it.  

<hr />
<sup>*</sup> Other ORM libraries are available.
