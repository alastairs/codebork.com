---
layout: post
title: 'Revisiting the SOLID Principles: SRP for Methods?'
author: alastairs
nid: 154
created: 1296786212
---
Over the weekend, I attended <a href="http://developerdeveloperdeveloper.com/ddd9/" title="DDD9">DDD9</a>, a really excellent and free event for developers.  The event was held at Microsoft's office in Reading, but was not a Microsoft event: Microsoft employees are forbidden from speaking.  This really is the premier developer event in the UK.  

I may do a round-up of the day here shortly, but in the meantime, I wanted to re-visit a topic I've touched on here before: <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html" title="SOLID Princples of OOD">the SOLID principles</a>, and specifically the Single Responsibility Principle (SRP).  One of the sessions I attended at DDD9 covered the SOLID principles in some depth (thanks, <a href="http://designcoderelease.blogspot.com/">Nathan</a>!) and this triggered a thought I'd had previously regarding the first of these principles, the Single Responsiblity Princple.
<!--break-->
The thought was relatively simple: could &mdash; <em>should</em> &mdash; the SRP be applied to methods as well as classes?  As it stands, the definition of the SRP, and indeed of the other SOLID principles, is in terms of class design, rather than member design:

<blockquote>
A class should have one, and only one, reason to change.
</blockquote>

Over the last couple of years since I wrote my original post on the SOLID principles, I have frequently been trying to apply the SRP to methods as well as classes.  This is, in part, due to my misremembering the exact definition of the SRP, and believing it to encompass members of a class as well as the class definition itself; I think, however, that applying the SRP sparingly to methods may result in cleaner code than restricting its use to classes only.  

<strong>Update: My friend <a href="http://blog.analysisuk.com/" title="Analysis UK blog">Steve</a> pointed out that my code example violated the SRP at a class level.  There's more than a hint of irony there :-)  As a result, I've updated this post with a new, improved example, and learned not to write blog posts late at night. Thanks go to Steve also for his feedback on the new examples. Enjoy.</strong>

Consider the following situation: an ASP.NET MVC action must display a particular record retrieved from a database, given the record's identifier.  

<script src="https://gist.github.com/812575.js?file=MethodMultipleResponsibilities.cs"></script>

I count one, maybe two possible reasons for this method to change, i.e., two responsibilities it must handle:
<ol>
  <li>Building the view model.  What happens if you need to add an extra field to the view, or </li>
  <li>Returning the correct <code language="csharp">ActionResult</code>.  What happens if you want to return the record in JSON format for display via an AJAX call?  A new method parameter would be required to indicate that preference, or a new Action would need to be created to handle the situation.  There are pros and cons to both approaches, but if you chose the first, how would you implement that choice?  A simple if statement selecting the right ActionResult?  Delegate to a new method to get the right ActionResult?  Implement a new controller for the JSON actions?</li>
</ol>

Note that I left out retrieving the record from the database. I consider this to be already delegated to the repository object, and so isn't a responsibility of the Action itself; instead, the Action is simply querying the repository for the appropriate record.  

My preferred implementation for this routine would therefore be something like:

<script src="https://gist.github.com/812575.js?file=MethodsSingleResponsibility.cs"></script>

Of course, the downside of this approach is that you start to end up with a long call stack, and lots of very small methods that don't do much (= more code).  I would argue, however, that for methods above a certain complexity, your code will be vastly more readable if you break your methods into smaller chunks, each with a defined responsibility.  I would even go so far as to suggest that it might be a good pattern to use for class interface (i.e., public) methods: these often provide a fa&ccedil;ade composing a number of individual actions.  In my opinion, each of those actions should be encapsulated in their own method.  

Indeed, one of <a href="http://www.martinfowler.com/" title="Martin Fowler's homepage">Martin Fowler's</a> <a href="http://www.refactoring.com/index.html" title="Refactoring Patterns">refactoring patterns</a> is called <a href="http://www.refactoring.com/catalog/extractMethod.html" title="Extract Method Refactoring Pattern">Extract Method</a>, and suggests that, when you have a code fragment that can be grouped together, you create a new method encapsulating that fragment and give the new method a name explaining the purpose of the method.

I briefly debated this with one of the more senior developers at Citrix a while back: he was of the opinion that the SRP should only be applied to classes, and not methods, I think on the basis that classes were what the SRP was defined for, and it's ok for methods to have multiple responsibilities, because that might be necessary for the routine to complete correctly.  

I think the readability concern is the important one here.  As we all know, <a href="http://blog.stackoverflow.com/2009/03/it-stack-overflow-update-naming-is-hard/" title="IT Stack Overflow Update: Naming is Hard">naming is hard</a>, and it is important to give methods (and variables, fields, etc.) good names in order to promote readability.  It becomes very difficult to give a method a good descriptive name if the method is doing multiple things: RetrieveRecordAndBuildViewModel() is a good name, but TryRetrieveRecordAndBuildViewModelAndDoSomethingElse() is starting to get silly.  BuildViewModel(record) is a better name, and the design has improved too with the Record dependency passed in as a parameter.  

I'm not advocating the use of the SRP in every method, as I believe this would actually hurt maintainability and readability, but for sufficiently complex methods, and for class interface methods, I think it makes sense to apply it.  Let me know what you think; I'm interested in generating discussion here.
