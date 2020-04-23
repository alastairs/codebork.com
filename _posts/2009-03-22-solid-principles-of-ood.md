---
layout: post
title: SOLID Principles of OOD
author: alastairs
nid: 72
created: 1237766048
---
Sadly for all you <a href="http://www.macmillandictionary.com/new-words/050425-Whovian.htm" title="Definition of &quot;Whovian&quot;">Whovians</a> out there, I don't mean <em>those</em> Ood.  Instead, I want to talk about the SOLID Principles of Object-Oriented Design, as proposed by "Uncle" Bob Martin back in the mid-1990s.  The SOLID Principles gained a level of notoriety in the .NET community a couple of months ago, after <a href="http://www.codinghorror.com/">Jeff Atwood</a> and <a href="http://www.joelonsoftware.com/">Joel Spolsky</a> made some, er, <em>unguarded</em> comments about them in <a href="http://itc.conversationsnetwork.org/audio/download/ITC.SO-Episode38-2009.01.20.mp3">one of their StackOverflow podcasts</a>.  This post is long overdue, so I'm glad to finally get it out there! :-)

[img_assist|nid=71|title=|desc=|link=node|align=center|width=400|height=233]
<!--break-->
The SOLID Principles of OOD are a bunch of guidelines for developing object-oriented systems.  They can be interpreted rigidly, and indeed religiously, or they can be applied in a more relaxed fashion.  The key, as with any of these principles and practices we learn, is to stick to them in general, and know them well enough to be able to correctly judge when to bend them.  You can find the full definitions of the SOLID Principles in Uncle Bob's <a href="http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod" title="Uncle Bob's Principles of OOD">original blog post</a>; alternatively, you can hear it straight from the horse's mouth in <a href="http://www.hanselminutes.com/default.aspx?showID=163" title="SOLID Principles with Uncle Bob &mdash; Robert C. Martin">episode #145</a> of <a href="http://www.hanselminutes.com/" title="Hanselminutes">Hanselminutes</a>.  I'm just going to summarise the five main principles of class design; you may be surprised to see that they're actually pretty simple, and that you're probably already following a number of them unwittingly.  Take a look:

<dl>
  <dt><strong><a href="#SRP">Single Responsibility Principle</a></strong></dt><dd>A class (or method) should only have one reason to change.</dd>
  <dt><strong><a href="#OCP">Open Closed Principle</a></strong></dt><dd>Extending a class shouldn't require modification of that class.</dd>
  <dt><strong><a href="#LSP">Liskov Substitution Principle</a></strong></dt><dd>Derived classes must be substitutable for their base classes.</dd>
  <dt><strong><a href="#ISP">Interface Segregation Principle</a></strong></dt><dd>Make fine grained interfaces that are client specific.</dd>
  <dt><strong><a href="#DIP">Dependency Inversion Principle</a></strong></dt><dd>Program to the interface, not the implementation.</dd>
</dl>

<h4 id="SRP">The Single Responsibility Principle</h4>
The crux of this principle is that not only should a class encapsulate an idea, such as a blog post, but that encapsulation should be quite restricted to "real" properties and behaviours of that idea.  This means that all ancillary operations related to the idea should be split out into separate classes.  Using the blog post example, your blog post class might have a <code>SaveToDatabase</code> method and a <code>RenderHtml</code> method.  A change in the database schema or display layout would result in a change in the class.  This is in violation of the Single Responsibility Principle, because <strong>these two methods change for two different reasons</strong>.  <code>SaveToDatabase</code> more properly belongs in a <a href="http://www.alastairsmith.me.uk/coding/2009/01/24/mocking-databases.html" title="Mocking Databases">Repository class</a>, and <code>RenderHtml</code> in the View part of a Model-View-Controller pattern.  

<h4 id="OCP">The Open Closed Principle</h4>
Software modules should be open for extension and closed for modification.  Stop and think about that for a moment.  <strong>Open for extension and closed for modification.</strong>  What does that even mean?!

Well, to my mind, it essentially means that you should treat your modules (classes, methods, assemblies, whatever) as black boxes <em>unless you are working directly on that module</em>.  If you have a <code>Foo</code>, and you want to extend it to make a <code>FooBar</code>, you shouldn't have to do anything to <code>Foo</code> to get your <code>FooBar</code>.  This comes down to writing good, clean interfaces to your modules, and utilising polymorphism to its fullest extent.  For example, you might have an <code>Account</code> base class; you could then use polymorphism to define, manipulate, and otherwise work with various accounts such as <code>CurrentAccount</code> (with an overdraft facility), <code>CreditCardAccount</code> (with a credit limit), etc.  <code>Account</code> is marked as abstract, and defines the core functionality of a financial account: recording transactions.  The subclasses modify the abstract base class' behaviour by introducing a kind of limit on the balance: the overdraft or credit limit.  <strong>You add new features by adding new code, not by changing existing, tested code.</strong>  How's that for robust?

<h4 id="LSP">The Liskov Substitution Principle</h4>
This follows on nicely from the Open-Closed Principle.  Given an abstract class or interface, anything that refers to it should be able to handle one of its derived classes.  It's sort of another way of saying that "a rose is a rose is a rose is a rose".  That's all a bit of a mouthful, so let's try an example.  

If you drive a Ford, you should also be able to drive a Toyota.  Or a Hyundai.  Or a Volkswagen, Mercedes or Ferrari.  A car is a car is a car is a car: <strong>given the abstract class of "car", you should be able to drive that car, no matter what make and model it is.</strong>  

A good metaphor for the Liskov Substitution Principle not being followed is Microsoft Office.  For many years, they got by with the menu-based system.  With the release of Office 2007 they introduced a new Ribbon interface.  Suddenly people didn't know how to use Office 2007.  A similar thing happens with new release of Windows: try finding anything in the Vista Control Panel if you're used to XP (the same applies to the XP Control Panel if you're used to Windows 98, 2000, etc.).  In order for these new interfaces to be adopted, a form of the Liskov Substitution Principle has to be applied; hence Microsoft's efforts to get third-party developers using the Ribbon and the similarity between Vista's Control Panel and Windows 7's.  

How does this apply to your code?  Well, is a square a rectangle?  Your instinct might be to say "yes, it's a special case of the rectangle"<sup>*</sup>.  That's not strictly true, though: what does it mean to talk of a square's height and width as opposed to a rectangle's height and width?  When implementing squares and rectangles in code, the rectangle should rather be a generalisation of the square than the square a specialisation of the rectangle, otherwise your subclasses do not behave like their superclass.  

<h4 id="ISP">The Interface Segregation Principle</h4>
This principle applies to very fat classes, i.e., with many tens or hundreds of methods, and draws on the theme of <a href="#SRP" title="The Single Responsibility Priniciple">the Single Responsibility Priniciple</a>.  Very often, only subsets of the members of classes like these are used at any one time, but because they're all defined in the same class, a client of that class may need to change because part of the fat class has changed (often even if it's an unrelated part of the fat class).  The idea here, then, is to <strong>define those subsets of methods as interfaces, and have the fat class implement each interface</strong> (or, ideally, split the subsets into smaller classes implementing those interfaces).  You can then pass around references to these interfaces (see <a href="#DIP" title="The Dependency Inversion Principle">the Dependency Inversion Principle</a>, below) rather than the full fat class, meaning that you only have available the methods that are relevant to that particular usage of the class.  It's a bit like partitioning the class according to function, with the option of easier re-factoring in the future.  

<h4 id="DIP">The Dependency Inversion Principle</h4>
In Uncle Bob's own words, this is like a restatement of the Open-Closed Principle with a 90-degree rotation.  Put simply, this says "depend only on things which are abstract", what I have called in the past, "interface programming" or "programming to the interface".  In essence, you should not rely on any concrete implementations of any classes, be they your own or framework objects.  For example, in the .NET framework, there are a number of List classes: <code>List</code>, <code>LinkedList</code>, etc.  If you declare a class member of type <code>List</code>, and then realise that a <code>LinkedList</code> would be better (performance reasons, whatever), you have to go through and change all <code>List</code> declarations that may handle your list.  If instead you had referred to it as an <code>IList</code> throughout, all you'd need to do is change the line(s) that construct the list object.  If you realise that a <code>List</code> is <em>far</em> too specific, an <code>IEnumerable</code> or even <code>ICollection</code> would be a better choice.  

This is one of the best lessons I learnt during my internship at Citrix back in 2006, and it's stayed with me ever since.  <strong>Using interfaces greatly simplifies your code, because you end up dealing with a number of Foo-shaped boxes into which you can slot any form of Foo you like.</strong>  If I wanted a Collection-shaped box, I could use any form of Collection I liked, be it List or not.  

<h4>Conclusion</h4>
The sum of these principles is a set of guidelines that will help you write good, clean, testable code.  Give them a whirl in your next coding task, and see what you make of them.  Then leave me a comment!

<hr />

<sup>*</sup> I made this mistake in an interview once.  Oops.
