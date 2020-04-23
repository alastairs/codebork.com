---
layout: post
title: 'Code Complete: Design in Construction (Part 3 - Design Building Blocks: Heuristics)'
author: alastairs
nid: 99
created: 1248551516
excerpt: !ruby/string:Sequel::SQL::Blob "Ok, so this is my first post on <em>Code
  Complete</em> for a little while; it turned out the busy period at work lasted a
  good couple of weeks longer than I thought it would!  It was a quite a while back
  that I made these notes (mid-June, in fact), so if the post seems less coherent
  or I've got something obviously wrong, please leave a comment.  Here be dragons.\r\n\r\nThis
  post deals with design heuristics.  We've already touched on what heuristics are
  in the <a href=\"http://www.codebork.com/2009/05/13/code-complete-software-development-metaphors.html\"
  title=\"Code Complete: Software Development Metaphors\">Software Development Metaphors</a>
  post, so you might want to refresh your understanding before reading on.  Inside,
  I will cover McConnell's description and critical evaluation of the most common
  design heuristics.  These can be viewed as smaller steps in a larger process, or
  as individual methods to use at different stages of the design process.\r\n\r\n<strong>Note:
  this is a long post!</strong>\r\n\r\n[img_assist|nid=103|title=Chocolate Heuristics|desc=Copyright
  &copy; 2006 <a href=\"http://www.flickr.com/photos/maadmob/\" title=\"maadmob on
  Flickr\">maadmob</a>|link=url|url=http://www.flickr.com/photos/maadmob/|align=center|width=400|height=330]\r\n"
---

Ok, so this is my first post on <em>Code Complete</em> for a little while; it turned out the busy period at work lasted a good couple of weeks longer than I thought it would!  It was a quite a while back that I made these notes (mid-June, in fact), so if the post seems less coherent or I've got something obviously wrong, please leave a comment.  Here be dragons.

This post deals with design heuristics.  We've already touched on what heuristics are in the <a href="http://www.codebork.com/2009/05/13/code-complete-software-development-metaphors.html" title="Code Complete: Software Development Metaphors">Software Development Metaphors</a> post, so you might want to refresh your understanding before reading on.  Inside, I will cover McConnell's description and critical evaluation of the most common design heuristics.  These can be viewed as smaller steps in a larger process, or as individual methods to use at different stages of the design process.

[img_assist|nid=103|title=Chocolate Heuristics|desc=Copyright &copy; 2006 <a href="http://www.flickr.com/photos/maadmob/" title="maadmob on Flickr">maadmob</a>|link=url|url=http://www.flickr.com/photos/maadmob/|align=center|width=400|height=330]

The first heuristic covered is by-the-book Object Orientation, <strong>finding real-world objects</strong> that model the system's concepts.  This is not stated in the sense that "oh, the Peregrine Falcon is a perfect description of the order processing subsystem: efficient and graceful", but rather that an order is placed for a customer; has a number of lines on the invoice, each of which is for a stock item, and a total price; and might be processed by a particular member of staff.  What I've done in that last sentence is to identify some of the common objects (customer, order, item, employee) and attributes (lines, total price).  Furthermore, we can look at the actions that can be done to each object ("place the order", "charge the customer", "ship the order"), and what each object can do others (an Account Manager might place the order on behalf of the customer).  At a greater level of detail, we can determine the visibility of the object's members (e.g., the customer might not be able to view the item's identifier; the employee might not be able to view the customer's credit card details; the order can view the totals of all the order lines), and from that define each object's public interface. 

The next heuristic is to <strong>form consistent abstractions</strong> across the system you are designing.  This is accomplished by defining good class interfaces, and providing larger programming abstractions.  McConnell illustrates this last point with the metaphor of building a house: a builder will install doors after the carpenter has crafted them from the base materials (e.g., wood, steel, glass, etc.).  The builder works with the larger abstraction of "door" over the smaller abstraction of "large sheet of glass".  

The third heuristic, <strong>encapsulating implementation details</strong>, is an effective technique for managing complexity.  If the encapsulation is done well, it prevents you from looking at the complexity, and then the old adage of "out of sight, out of mind" starts to take hold.  If your encapsulation is poor, you end up having to manage the implementation detail (and therefore more of the complexity) on a daily basis.  

The OO idea of inheritance is a powerful one, and as such McConnell suggests it be treated with care and respect.  In fact, he goes a bit further than that to suggest that <strong>it should only be used when it simplifies the design</strong>.  There was recently an example at work that bears this out.  In my component, we have two Change Password operations, one for each of before and after the user has logged in.  The "external" (pre-login) Change Password class inherits from the "internal" (post-login) class, which has saved a fair bit in terms of duplication of code, etc.  However, there's not a great deal of inheritance used elsewhere in the component, and so tracing the flow of execution between the two is non-obvious and can be quite tricky, not least because both classes are called <code language="java">ChangePassword</code>!

McConnell's fifth heuristic covers the idea of <strong>information hiding</strong>, specifically secrets.  This has benefits in that again it emphasises hiding complexity, this time based on the iceberg principle (i.e., that the vast majority of the inner workings of the class, and therefore its complexity, should be behind the public interface).  Information hiding will help you at all levels of the design, be it working out how the high-level components of the system fit together, or how a subsystem processes input from a file.  

[img_assist|nid=102|title=Complexity should be 7/8 below the surface too|desc=|link=node|align=center|width=219|height=299]

There are some barriers to information hiding, however.  Most notably, these include circular dependencies and perceived performance penalties from creating more classes, hitting more methods, etc.  In reality, these days, the performance penalty caused by information hiding is negligible in all but the most esoteric of situations.  Other behaviours that can cause difficulties with information hiding are excessive distribution of information (where too many diverse bits of the system know about the same bit of information), and class data being mistaken for global data.  

However, information hiding has proven to be useful in many systems implemented, and McConnell states that it has a unique ability to produce effective design solutions.  You should, therefore, get into the habit of asking <strong>"What should I hide?"</strong>.

The sixth heuristic is to <strong>identify areas likely to change</strong>.  McConnell proposes a three-step process for achieving this:
<ol>
  <li>Identify items likely to change</li>
  <li>Separate items that are likely to change</li>
  <li>Isolate items that seem likely to change</li>
</ol>

There are a number of items that are likely to change.  Examples include business rules (e.g., keeping up with changing tax regulations, etc.), hardware dependencies, non-standard language features, status variables, areas that are difficult to design and construct, and more.  Separating these items involves compartmentalising them into their own classes, or grouping them into a class with similar items.  To achieve step 3, isolation of items likely to change, you need to ensure the public interfaces are insensitive to the potential changes.  This does involve anticipating areas of change, which is no mean feat, but I am starting to find that this is the sort of thing that experience teaches you.

<strong>Reducing coupling</strong>, and keeping it loose, is an excellent design heuristic, and something that <a href="http://www.pragprog.com/" title="The Pragmatic Bookshelf">the Pragmatic Programmers</a> describe at some length.  Taking their analogy, a tightly-coupled system is like a helicopter: moving the joystick requires adjustments to the rudder and other controls to keep the craft balanced.  Everything is inter-related, and a small change here could affect something else in a non-obvious, or trivial, or confusing way.  A loosely-coupled system, however, provides small, direct, visible and flexible relations.  The size of a coupling is measured by the number of connections, whilst the visibility is measured by the prominence of the connection.  Flexibility describes how easily the connections change.  

McConnell lists a small number of examples of the types of coupling (in ascending order, loosely-coupled to tightly-coupled):
<dl>
  <dt><strong>Simple-data-parameter:</strong></dt> <dd>all data are of primitive 
types and passed through parameter lists</dd>
  <dt><strong>Simple-object:</strong></dt> <dd>instantiates the object</dd>
  <dt><strong>Object-parameter:</strong></dt> <dd>if A requires B to pass it a C then B needs to know about C too</dd>
  <dt><strong>Semantic:</strong></dt> <dd>A uses some semantic knowledge of another module's inner workings</dd>
</dl>

I found these slightly confusingly-named, but well-explained.  Hopefully the summarised explanations above show that the concepts aren't too tricky to understand.  

McConnell then covers the idea of <strong>using common patterns</strong> in your designs.  These can reduce complexity through their ready-made abstractions, and can reduce errors by institutionalising details of common solutions.  There is a huge amount of value in being able to say "we're writing a Database Abstraction Layer here, the Bridge pattern describes this situation well", both in terms of easing your own understanding of the problem and the implementation.  In and of themselves, they provide heuristic value by suggesting design alternatives, and can streamline communication by moving the conversation to a higher level.  It's much easier to talk about an interface that's implementing the Fa&ccedil;ade pattern by referring to a Fa&ccedil;ade than it is by frequently and repeatedly describing the interface as "something the simplifies the use of the underlying subsystem by grouping the most common and useful functionality into the single interface".  

Last of all, McConnell covers a small selection of other design heuristics.  I'm not going to cover them in any detail here, but instead simply list them with a short description.  

<dl>
  <dt><strong>Aim for strong cohesion:</strong></dt> <dd>i.e., highly-focussed classes and modules</dd>
  <dt><strong>Build hierarchies:</strong></dt> <dd>improve organisation</dd>
  <dt><strong>Formalise class constructs:</strong></dt> <dd>preconditions and postconditions</dd>
  <dt><strong>Assign responsibilities</strong></dt>
  <dt><strong>Design for test:</strong></dt> <dd>TDD can help, but it's not the be-all and end-all</dd>
  <dt><strong>Avoid failure:</strong></dt> <dd>consider ways the system might fail, e.g., threat modelling</dd>
  <dt><strong>Choose binding time consciously</strong></dt>
  <dt><strong>Make central points of control:</strong></dt> <dd>One Right Place</dd>
  <dt><strong>Consider using brute force</strong></dt>
  <dt><strong>Draw a diagram</strong></dt>
</dl>
