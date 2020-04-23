---
layout: post
title: 'Code Complete: High-Quality Routines (Part 1 - Introduction and Design Considerations)'
author: alastairs
nid: 138
created: 1272665156
---
Last time, <a href="http://www.codebork.com/coding/2009/11/04/code-complete-reasons-create-class.html" title="Code Complete: Working Classes (Part 4 - Reasons to Create a Class)">I rounded off the series-within-a-series on class design and usage, Working Classes</a>.  The next topic for dissection is routine design, creation and usage, and this topic will be handled over two posts.  This post will form a bit of an introduction and cover design considerations for high-quality routines through the classification of different kinds of routine cohesion.  So, without further ado, let's get cracking!
<!--break-->
A good place to start is to define what a routine is, and McConnell describes it as <strong>an individual method or procedure invokable for a single purpose.</strong>  Note that implicit in this definition is an assumption that the <a href="http://www.codebork.com/2009/02/18/solid-principles-ood.html#SRP" title="SOLID Principles of OOD">Single Responsibility Principle</a> applies to methods as well as classes.  

McConnell then provides an example of a low quality routine, and suggests to the reader that they pick it apart and find as many errors in it as they can.  I've included my opinions and then McConnell's answers below; don't scroll too far if you want to try this exercise for yourself.  The routine is as follows (as printed in <em>Code Complete</em>, 2nd Edition):

<blockcode language="cplusplus">
void HandleStuff( COPY_DATA & inputRec, int crntQtr, EMP_DATA empRec,
    double & estimRevenue, double ytdRevenue, int screenX, int screenY,
    COLOR_TYPE & newColor, COLOR_TYPE & prevColor, StatusType & status,
    int expenseType)
{
int i;
for ( i = 0; i< 100; i++ ) {
    inputRec.revenue[i] = 0;
    inputRec.expense[i] = corpExpense[ crntQtr][ i ];
    }
UpdateCorpDatabase( empRec );
estimRevenue = ytdRevenue * 4.0 / (double) crntQtr;
newColor = prevColor;
status = SUCCESS;
if ( expenseType == 1 ) {
    for ( i == 0; i < 12; i++ )
        profit[i] = revenue[i] - expense.type1[i];
    }
else if ( expenseType == 2 ) {
        profit[i] = revenue[i] - expense.type2[i];
        }
else if ( expenseType == 3 ) {
        profit[i] = revenue[i] - expense.type3[i];
        }
</blockcode>

I picked out the following things as being bad practice or otherwise wrong:
<ul>
  <li><strong>Bad method name:</strong> <code>HandleStuff</code> is a very vague name that gives no hints as to what the routine is supposed to achieve.</li>
  <li><strong>No comments:</strong> There is no routine comment describing the purpose of the routine, its parameters and return value, nor are there any comments in the routine's implementation to describe trickier or non-obvious corners of the code.</li>
  <li><strong>Too many parameters:</strong>  This is a matter of taste, but it suggests to me that there may be scope to create an object to wrap the parameters, provided they are sufficiently closely-related.</li>
  <li><strong>Parameters are unrelated:</strong> This causes confusion over what the routine might be doing.  Indicates that the routine has more than one responsibility.  </li>
  <li><strong>Braces inconsistent and confusing:</strong> Along with the poor indentation, this is a major barrier to the routine's readability and therefore its comprehensibility.  </li>
  <li><strong>Reuse of loop variable i in different places in the routine:</strong>  This is particularly bad, as we will see when we get onto the chapter on variables.  Not only does i have little meaning outside of a loop, but also the routine becomes reliant on side-effects; i.e., that the loops complete at the expected iteration, that the variable is in the right state before the next loop begins, etc. </li>
  <li><strong>Has more than one responsibility:</strong> This routine updates a database, calculates estimated revenue, and sets a colour of some sort.  It therefore has no focus and sprawls.</li>
  <li><strong>Outputs data via parameters rather than returning value:</strong> This isn't bad practice in and of itself, but here it doesn't make a lot of sense, and is another symptom that the routine is trying to do too much.  At least one of the data items could be returned (perhaps the status)</li>
  <li><strong>Status is set to SUCCESS before the second half of the function has completed:</strong> Does status refer to a particular action in the first half of the routine, or the routine as a whole?  If the latter, there's still plenty of time for something to go wrong; if the former, it's poorly-named.</li>
  <li><strong>Using magic numbers in if statement:</strong> What is expenseType 1?  You might know when you wrote this code, but you may not three months down the line, and a new developer on your team most certainly won't.</li>
  <li><strong>using if statement over switch:</strong> If the language supports <code>switch</code>ing on an int, then this provides a more readable alternative to sequence of <code>if..else if</code></li>
  <li><strong>No checking of crntQtr value for valid data:</strong>  What happens if crntQrtr is 0?  Or 3.14159?  Or 14?</li>
</ul>
 
Here's McConnell's list of answers:
<ul>
  <li>Bad name</li>
  <li>No comments</li>
  <li>Bad layout.  Different layout strategies are mixed and matched.</li>
  <li>Input variable, inputRec, is changed (or it should be renamed so it's not classed as an input variable)</li>
  <li>Reads and writes global data (profit, crntQtr)</li>
  <li>No single purpose</li>
  <li>No defence against bad data</li>
  <li>Use of magic numbers</li>
  <li>Some parameters are unused (screenX and screenY)</li>
  <li>prevColour is passed as a reference parameter even though it isn't assigned a value</li>
  <li>Too many parameters (upper limit should be 7 for an understandable method), and they're laid out in an unreadable way</li>
  <li>Parameters are poorly ordered and undocumented.</li>
</ul>

So, with that in mind, what are the valid reasons to create a routine?  Well, as we saw last time with creating classes, <strong>the single most important reason to create a routine is to reduce complexity.</strong>  Again, this is an effective technique for hiding information so you don't have to juggle that along with the rest of the routine.  The deep nesting of an inner loop or conditional is a prime target for the Extract Method refactoring.  

Routines are a great tool for managing duplication, and indeed avoiding it in the first place.  If reducing complexity is the most important reason to create a routine, avoiding duplicate code is the most popular.  If you find yourself creating similar code in different routines, then you likely have an error in your decomposition: at this point, you can pull out the duplicate code, place a more generic version in a common base class, and move the specialised routines into subclasses; alternatively, you can move the common code into its own routine and let both methods call the new routine.  Furthermore, this saves space used by the duplicated code, making modifications easier because you only have to update one place, and making your code more reliable as there is only one place to check to ensure the code is correct.  

[img_assist|nid=139|title=|desc=Photo by <a href="http://www.flickr.com/photos/jcse/" title="José Encarnação on Flickr">José Encarnação</a>|link=none|align=center|width=400|height=300]

You can create new routines to support subclassing, as well.  Less code is needed to override a short, well-factored routine than a long and sprawling routine, because the original routine is clearly-defined and well-understood.  As a result, simple overridable routines can help reduce the chance of error in the subclass implementations.  

In any program, it's sensible to hide the order in which events happen to be processed from the wider world, because it shouldn't matter beyond the scope of the routine.  In a blog application, for example, you don't really want the code dealing with saving data to know that a connection to the database must be set up and opened, and an SQL statement prepared and populated with data, before the data can actually be saved to the database.  Instead, you can hide all this away in your <code>Save()</code> method, and ideally it would be factored out into separate routines on a dedicated class such as a <a href="http://www.codebork.com/coding/2009/01/24/mocking-databases.html">Repository</a>.  

If languages like C++ are your thing, routines can be used effectively to manage the pointer operations integral to these languages.  This technique is less appropriate to modern languages that abstract the pointer operations away from the developer's eyes, but it allows the developer to concentrate on the intent of the operation rather than its mechanics.  A similar argument holds for managing the portability of your system: using routines allows you isolate the non-portable capabilities of your system, such as database-specific functionality, from the rest of your system.  Such issues may not be applicable to your system, however.  

One of my personal favourite reasons to create a new routine is to simplify a complicated boolean test.  Understanding all the ins and outs of complicated boolean conditions is rarely necessary, and inlining them in your code presents a barrier to readability.  It's much easier to grok a complicated condition if it's wrapped in a method with a good, descriptive name: the finer details of the test are abstracted away and summarised nicely.  Furthermore, this emphasises the test's significance, encouraging your to expend extra effort to make the detail of the test clear and readable inside the function.  This is a technique I've used at work a few times recently, in both my own code and in code reviews, and it seems to be paying off well.  

Finally, you can introduce new routines to improve performance.  This is because it is easier to optimise the code in one place instead of several, and makes your code easier to profile.  

<strong>You should never introduce a new routine to ensure all routines are small.</strong>  This is a bit of an anti-pattern, and leads to arbitrary divisions of labour.  This is then usually compounded by the fact that such routines are difficult to name.  You very quickly end up with a mess.  
 
The biggest mental block to creating effective routines is a reluctance to create a simple routine for a simple purpose.  However, these make code more self-documenting.  Small routines can turn into larger routines, once newly-discovered errors are accounted for. Furthermore, many of the reasons to create a class are also good reasons to create a routine:
<ul>
  <li>Isolate complexity</li>
  <li>Hide implementation details</li>
  <li>Limit effects of change</li>
  <li>Hide global data</li>
  <li>Make central points of control</li>
  <li>Facilitate reusable code</li>
  <li>Accomplish a specific refactoring</li>
</ul>
 
<h3>Routine Cohesion</h3>
Cohesion, <a href="http://portal.acm.org/citation.cfm?id=1661066.1661068" title="Structured Design, IBM Systems Journal, Volume 13, Issue 2">introduced</a> by Wayne Stevens, Glenford Myers and Larry Constantine in 1974, is the workhorse design heuristic at the routine level.  Cohesion refers to how closely the operations within a routine are related, and can also be referred to as "strength".  The goal is to achieve maximum cohesion: each routine does one thing well and nothing else; this is known as functional cohesion.  The following forms of cohesion are considered poor, and prime for refactoring.  

[img_assist|nid=140|title=Cohesion|desc=Photo by <a href="http://www.flickr.com/photos/nogood/" title="Yannig Van de Wouwer on Flickr">Yannig Van de Wouwer</a>|link=none|url=http://www.flickr.com/photos/nogood/211866952/|align=center|width=399|height=266]

<strong>Sequential cohesion</strong> exists when a routine contains operations that must be performed in a specific order, sharing data from step to step, and don't make up a complete function when done together.
For example, in a routine that calculates age and time until retirement from a birth date, if the time to retirement is calculated from the result of the age calculation, the routine is considered sequentially cohesive. 
To make it functionally cohesive, create separate routines where each takes the birth date as a parameter.  Time-to-retirement could call the Age routine and each would still have functional cohesion.

<strong>Communicational cohesion</strong> is defined by operations in a routine that use the same data, but are otherwise unrelated.  For example, a given summary-printing routine also reinitialises the summary data; the operations can be split into separate routines, with the summary reinitialisation routine being called from the location where the summary is created in the first place. 

<strong>Temporal cohesion</strong> occurs when operations are combined into a routine because they're all executed together. <code>Startup()</code> and <code>Shutdown()</code> methods are prime examples of temporal cohesion.  Functional cohesion can be achieved by factoring out the individual jobs of the routine to separate routines and calling them from the original routine.
 
The following kinds of cohesion are generally unacceptable, and it is considered better to put in the effort to re-write them rather than put up with code that is poorly organised, hard to debug and hard to modify.

<strong>Procedural cohesion</strong> occurs when operations are done in a specified order (but don't necessarily share data).  A set of operations is organised into a specified order and the operations don't need to be combined for any other reason; a routine that gets an employee name, then an address, then a phone number would be considered procedurally cohesive.  To make the routine functionally cohesive, put the separate operations into their own routines, and make sure the calling routine has a single complete job (e.g., GetEmployee()).

<strong>Logical cohesion</strong> occurs when several operations are placed into a single routine, and one of the operations is selected by a control flag passed in as a parameter; i.e., only the control flow ties the operations together: they're otherwise separated out in a big if or switch statement together and the operations themselves are unrelated.  For example, a method called InputAll() can input customer names, timesheet info, or inventory data, depending on the flag passed in.  This can be improved by separating the operations into their own routines; if there is shared code between the operations, this is moved into a helper method and the operations are packaged into a class.  There is an exception, however: a routine containing nothing but a series of if or switch statements and calls to other routines.  McConnell terms this an "event handler", which is potentially a confusing term depending on your background.

<strong>Coincidental cohesion</strong> occurs when operations in a routine have no discernible relationship, and is also known as "no cohesion" or "chaotic cohesion".  Unfortunately this is not easily improved upon, and if you find yourself faced with a coincidentally cohesive routine, the only practical approach is to give it a deeper redesign and reimplementation.  

<h3>Conclusion</h3>
This post provided an introduction to key considerations for routines, including when to create new routines, when <em>not</em> to create new routines, and the concept of routine cohesion.  Part two will cover naming conventions for routines, and the use of routine parameters.
