---
layout: post
title: 'Code Complete: High-Quality Routines (Part 2 - Naming and Parameter Usage)'
author: alastairs
nid: 141
created: 1272745930
---
This second and final post on high-quality routines will cover good routine names and guidelines for parameter usage, as well as touching on routine length and special considerations for functions vs procedures.
<!--break-->
There are a number of things a routine name must achieve in order to be considered a good name.  First and foremost, <strong>they should describe everything the routine does, including all outputs and side effects.</strong>  This can lead to long and "silly" routine names, such as <code>ComputeReportTotalsAndOpenOutputFile()</code>, so the key here is to avoid programming with side effects rather than skimping on the routine name.  Furthermore, meaningless, vague, or wishy-washy verbs should be avoided, such as <code>DoWork()</code>, <code>HandleCalculation()</code>, <code>Process()</code>, etc.  "Handle" should only be used in the context of handling an event.  It can be the case that only the name is bad and routine itself is well-designed, but in most cases, the vague verb is a symptom of the vague purpose of the method. If this is the case, restructure the routine and its related routines so they have stronger purposes, and stronger names to boot.

Hopefully this point is self-evident, but don't differentiate routine names solely by number.  <code>ComputeReportTotals1()</code> and <code>ComputeReportTotals2()</code> are bad routine names: what's the difference between them?  Do they compute different totals, or operate on different reports?  Maybe they take different inputs?  This routine naming technique ruins what might otherwise be a good routine name by introducing ambiguity into the name, and uncertainty and doubt into its meaning.  

[img_assist|nid=142|title=|desc=|link=node|align=center|width=400|height=447]

Make the name as clear as possible, and as a logical follow-on from this point, make your routine names as long as necessary.  Whilst the optimum <em>average</em> length for a variable name is 9-15 characters, good routine names tend to be longer.  This can be bolstered by using a description of the return value for functions, such as <code>cos()</code>, <code>customerId.Next()</code>, <code>printer.IsReady()</code>, or <code>pen.CurrentColour()</code>; or by using a strong verb followed by an object for a procedure, such as <code>PrintDocument()</code>, <code>CalculateMonthlyRevenues()</code>, <code>CheckOrderInfo()</code>, <code>RepaginateDocument()</code>.  In OO languages, the object isn't strictly necessary, as the object itself is usually included in the call (<code>document.Print()</code>, <code>orderInfo.Check()</code>).  Names like document.PrintDocument() are redundant, and lose accuracy when carried through to derived classes.

Do use opposites precisely, and use naming conventions for opposites to aid consistency.  Common opposites include:
<table>
  <tr style="border-bottom: 1px solid silver;">
    <td style="border-right: 1px solid silver; padding: 5px;">Add/Remove</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Increment/Decrement</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Open/Close</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Begin/End</td>
    <td style="padding: 5px;">Insert/Delete</td>
  </tr>
  <tr style="border-bottom: 1px solid silver;">
    <td style="border-right: 1px solid silver; padding: 5px;">Show/Hide</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Create/Destroy</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Lock/Unlock</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Source/Target</td>
    <td style="padding: 5px;">First/Last</td>
  </tr>
  <tr style="border-bottom: 1px solid silver;">
    <td style="border-right: 1px solid silver; padding: 5px;">Min/Max</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Start/Stop</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Get/Put</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Next/Previous</td>
    <td style="padding: 5px;">Up/Down</td>
  </tr>
  <tr>
    <td style="border-right: 1px solid silver; padding: 5px;">Get/Set</td>
    <td style="border-right: 1px solid silver; padding: 5px;">Old/New</td>
    <td style="border-right: 1px solid silver; padding: 5px; background-color: #f8f8f8;">&nbsp;</td>
    <td style="border-right: 1px solid silver; padding: 5px; background-color: #f8f8f8;">&nbsp;</td>
    <td style="padding: 5px; background-color: #f8f8f8;">&nbsp;</td>
  </tr>
</table>
 
Establish your own conventions for common operations.  Naming conventions are the easiest way to distinguish among different kinds of operations.  The following examples are all valid ways of retrieving an object's identifier &mdash; <code>employee.id.Get()</code>, <code>candidate.id()</code> or <code>dependent.GetId()</code> &mdash; but they should be standardised for your program.  
 
Regarding routine length, some research has been carried out into the optimum length for maintainability, comprehensibility, etc., but the results have so far proved inconclusive.  A significant percentage of object-oriented code is accessor routines, which are generally very short (often just one line), and generally should be kept as simple as possible, with extra processing handled in other routines.  Complex algorithms lead to longer routines, and these should be allowed to grow organically up to 100-200 lines: experience shows that routines of this size are no more error-prone than short routines.  Be careful with routines larger than ~200 lines, as they are harder to understand, and therefore maintain.  Issues such as <a href="http://www.codebork.com/coding/2010/04/29/code-complete-high-quality-routines-part-1-introduction-and-design-considerations." title="Code Complete: High-Quality Routines (Part 1 - Introduction and Design Considerations)">cohesion</a>, depth of nesting, the number of variables used, the number of decision points, and the number of comments needed to explain the routine, and other complexity-based considerations should dictate the length of the routine. 

[img_assist|nid=143|title=Enough with the names already|desc=Photo by <a href="http://www.flickr.com/photos/jamescridland/" title="James Cridland's Flickr Photostream">James Cridland</a>|link=none|align=center|width=400|height=219]

<h3>Routine Parameters</h3>
Interfaces between routines are very error-prone, because the syntax rules governing parameter lists are few in number and generally weak in force in comparison with classes.  The guidelines outlined in this section should help you minimise problems caused by routine interfaces.  

Putting parameters in input-modify-output order brings some semblance of order to what otherwise might be a somewhat random jumble of mostly-related data items: it implies the sequence of operations within the routine.  Alphabetical ordering &mdash; and random ordering in particular &mdash; are detrimental to understanding the routine from its interface, as the order makes no sense in the problem domain.  Furthermore, you should consider using different naming conventions for input, modify and output parameters to highlight the differences between them.  Status or error variables should always be placed last in the list.  As these are output parameters by definition, they should come at the end of the parameter list anyway, but they should be the very last items in the list, in the same way that <a href="http://www.codebork.com/coding/2010/04/29/code-complete-high-quality-routines-part-1-introduction-and-design-considerations." title="Code Complete: High-Quality Routines (Part 1 - Introduction and Design Considerations)">they should be set last in the routine</a>.  If several routines use similar parameters, always order those parameters consistently, as this aids remembering how to use the routines, and be sure to <strong>use all the parameters</strong>!  If you're not using a parameter in a routine, remove it.

Consider creating your own in and out keywords; this helps highlight which parameters have which role (input/modify/output).  C# has <code>out</code> (output only) and <code>ref</code> (input-output) keywords that fulfil this requirement (<code>ref</code> parameters must be initialised before passing in; <code>out</code> parameters cannot be; input parameters are implicit and the default), but Java doesn't support this at all: all parameters are pass-by-value.  Furthermore, Java doesn't support macros and preprocessing like C and C++ do, so you don't really have the option to add them in.  They <em>can</em> be added in C and C++, but the effect is only really to improve the documentation of the routine, as you still need to pass pointers and reference parameters.  There are some drawbacks to this approach: it extends the language in a way unfamiliar to most users (so you need to be disciplined in using your custom extensions consistently), nor is it enforceable by the compiler which could lull developers into a false sense of security when reading your code.

Don't use routine parameters as working variables, use local working variables instead.  This allows you to use the parameter value again later in the routine should you need to.

[img_assist|nid=144|title=Selfridge's Parametric Bridge|desc=Photo by <a href="http://www.flickr.com/photos/ell-r-brown/" title="Ell Brown's Photo Stream on Flickr">Ell Brown</a>|link=url|url=http://www.flickr.com/photos/ell-r-brown/3846029441/|align=center|width=400|height=300]

Do document your interface assumptions about the routine's parameters, both in the routine and the location from where the routine is called.  Even better than documenting the assumptions, if your language supports it, is to use assertions to enforce the assumptions.  Some examples of assumptions that should be documented are whether parameters are input-only, modified, or output-only; the units of numeric parameters (feet, inches, kilograms, etc.); the meanings of status codes and error values (if enums aren't used); the ranges of expected values; and specific values that should never occur.  

Try to limit the number of parameters to a routine to approximately seven.  This is a direct result of <a href="http://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two" title="The Magical Number Seven, Plus or Minus Two (Wikipedia)">the 7 ± 2 rule</a> proposed by George Miller in 1956, which theorises that the average capacity of the human brain's short-term memory is seven items, plus or minus two.  In modern and object-oriented languages, you can pass many items into a routine using a complex data type such as a class or a struct.  If you find yourself consistently passing the same set of arguments, however, the coupling between the two routines is too high.  The routines should be grouped into a class, with the frequently-used data promoted to class data, such as fields or properties.  

You should pass the variables or objects that the routine needs to maintain its interface abstraction.  Generally, there are two schools of thought on how much of an object to pass through.  The first school says that only the specific object members needed by the routine should be passed in, whilst the second school says that the whole object should be passed in for greater flexibility in future.  McConnell believes that, in reality, both are too simplistic, and instead you should pass in the data that matches the routine's interface abstraction.  So, for example, if the routine expects three specific data elements, and the data are coincidentally provided by a single object, and you happen to have the whole object to hand, you should pass that in.  If you have to create the object prior to calling the routine, the data should be passed into the routine as separate items: a routine that requires "setup" or "teardown" generally needs re-designing.  If you find you're frequently changing the parameter list to add new object members, pass in the object.

Ensure that the actual parameters passed into the routine match the formal parameters declared on the routine: a common mistake is to pass (for example) an int when a float is requested.  I'm not sure how much I agree with McConnell's recommendation on this point: strongly-typed languages provide more than a modicum of protection against most type-based mistakes, and no information is lost when an int is implicitly converted to a float.  Furthermore, whilst this advice applies to input-only parameters, it can become difficult to apply to parameters that are used for both input and output.

The final recommendation on parameter usage is to use named parameters, which allow formal parameters to be associated with actual parameters.  Some languages have had these for a while, such as Visual Basic, Objective-C and Python, and <a href="http://msdn.microsoft.com/en-us/library/dd264739.aspx" title="Named and Optional Arguments (C# Programming Guide)">C# has just recently had this capability added with the version 4 language specification</a>.  The benefit of named parameters is that it clears up any ambiguity over which actual parameter binds to which formal parameter: the relations between the two sets are laid out for all to see in the routine call.  

<h3>Functions vs Procedures</h3>
I most modern languages no distinction is drawn between functions and procedures at a syntactic level.  Semantically, a function returns a value whilst a procedure does not; a procedure in Java or C#, then, is a method with a <code>void</code> return type.  Two exceptions that prove this rule are VB and Delphi: both languages draw a syntactic distinction between functions and procedures.  

You should use a function if the primary purpose of the routine is to return the value indicated by the function name.  Returning a status result should ideally be done via an output parameter, not least because it promotes the better (but more verbose) programming practice of separating the routine call and the test on the status result; that is, it avoids statements of the form <code>if (Save(data))</code>.

<h3>Conclusion</h3>
In this post, we looked at considerations for naming routines, and guidelines for using parameters.  We also drew a (small) distinction between functions and procedures, and looked at some factors affecting routine length.  That rounds up another sub-section in this series, and with it, another chapter of <em>Code Complete</em>.  

Chapter 8 covers defensive programming techniques such as exceptions and other error-handling techniques, assertions, and protecting your program from invalid inputs; and debugging aids.  This will likely form another mini-series like the "Working Classes" series as there is a lot of information and advice to cover from this chapter.
