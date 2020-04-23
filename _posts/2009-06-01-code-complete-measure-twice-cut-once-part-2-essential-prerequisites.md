---
layout: post
title: 'Code Complete: Measure Twice, Cut Once (Part 2 - Essential Prerequisites)'
author: alastairs
nid: 93
created: 1243811026
excerpt: !ruby/string:Sequel::SQL::Blob "<a href=\"http://www.codebork.com/coding/2009/05/21/code-complete-measure-once-cut-twice-part-1-importance-prerequisites.html\"
  title=\"Code Complete: Measure Twice Cut Once (Part 1)\">Part 1</a> of this post
  covered the importance of pre-requisites: why it is worth doing them, and doing
  them well; why it is a bad idea to jump straight into coding; and how to ensure
  that they are completed at your organisation (if they aren't automatically already).
  \ \r\n\r\nThis second post covers the three main pre-requisites, namely Problem
  Definition, Requirements, and Architecture.  \r\n\r\n<strong>Note: this is a long
  post!</strong>\r\n"
---

<a href="http://www.codebork.com/coding/2009/05/21/code-complete-measure-once-cut-twice-part-1-importance-prerequisites.html" title="Code Complete: Measure Twice Cut Once (Part 1)">Part 1</a> of this post covered the importance of pre-requisites: why it is worth doing them, and doing them well; why it is a bad idea to jump straight into coding; and how to ensure that they are completed at your organisation (if they aren't automatically already).  

This second post covers the three main pre-requisites, namely Problem Definition, Requirements, and Architecture.  

<h3>Problem Definition</h3>
The very first thing needed is a clear statement of the problem the system is supposed to solve.  As such, it should sound like a problem, such as "We can't keep up with orders for the Gigatron".  Sometimes problem definitions are worded more like solutions (e.g., "We need to optimise our automated data-entry system to keep up with orders for the Gigatron"); this is bad because it obscures the real issue and can quietly close off new alleys of thought that might lead to a better solution.  Problem definitions should be worded in user language, and written from the user's point of view.  Failing to define the problem well can waste a lot of time solving the wrong problem.  

<h3>Requirements</h3>
Why should we bother with the requirements pre-requisite?  From many years of software engineering projects (and many, many failed ones along the way), it has been found that good products are user-driven.  Requirements help ensure that the user, rather than the programmer, drives system functionality.  This is a big win for customer satisfaction: they get to specify what they want from the system and the completed system is acceptable to them because it meets their requirements.  It also helps avoid arguments within the development team over functionality; they provide a baseline to work to, and prevents programmers adding that neat (but ultimately useless) bit of functionality as they go.  Finally, the requirements help minimize code changes to a system after development begins.  As we saw in the last post, errors in requirements are expensive to fix after the requirements phase is complete; if done correctly, the requirements pre-requisite is a firm hand on the customer's prerogative to change the requirements for the project.  

Change in requirements can be very hard to accommodate, but unless you are very lucky, <em>requirements will change</em>.  McConnell provides a shortlist of items to check to help you deal with changing requirements.  The first of these is to use the provided requirements' check-list to assess the quality of your requirements.  You'll have to read the book to get this (and the other check-lists) I'm afraid!  

The second suggestion is to ensure that everyone knows the cost of requirements changes.  This is an education task as much as anything, and remember that we saw in the previous post that changes in requirements can cost anything up to 100x the "base" cost if made after this pre-requisite is completed.  This will help prevent the customer, project manager, bosses' bosses' bosses, etc., from taking the process of changing the requirements too lightly, and will ensure that it only happens for mission-critical items.  If you're at the code-face, be sure to keep your eye on the business case for the project and the feature in spite of the changing requirements, as this will help you tolerate the change.  You should actively try to incorporate the change into your perception of the business case for the project; discussing it with your team and the project manager (and other stakeholders) will help achieve this.  

Setting up a change control provider (such as Subversion or Git) will allow you to recover that dropped feature if necessary, and will also allow you to branch your code base for each feature, release, etc.  You can also adopt development approaches that accommodate changes (such as Agile methodologies).  In the recent <a href="http://www.noop.nl/2009/05/the-big-agile-practices-survey-report-part-1.html" title="The Big Agile Practices Survey Report (Part 1)">Big Agile Practices Survey</a> conducted by <a href="http://www.noop.nl/" title="NOOP.NL">Jurgen Appelo</a>, source control was voted the most important Agile practice by 100% of the sample (and, thankfully 100% of the sample responded that they implemented it, too).  It is one of those software development practices that should just be common sense in this day and age; not using source control is akin to jumping from a plane without a parachute.  

If all else fails, you can simply dump the project, although this is quite obviously an option of last resort.  If your organisation drops the project, it can be damaging to their reputation; equally, moving yourself on can be difficult within an organisation if you're leaving mid-project, and finding a position with a new organisation can take time.  As someone at work recently mentioned, 

<blockquote>"I've always found job hunting to be a full-time job."</blockquote>

<h3>Architecture</h3>
The quality of the architecture will determine the conceptual integrity of the system.  With the wrong architecture, you will be tackling the right problem but in the wrong way.  This can make construction trickier and more time-consuming.  

At all levels, and in all parts of the architecture, there should be evidence that alternatives were considered, and the decisions justified.  This is partly to head-off arguments further down the line when problems are run into (these kind of discussions might start off, "Why was the architecture designed this way?  It doesn't make sense in the context of this problem, it's making this harder."  Or it might be stronger language than that.)  These discussions aren't constructive when the team has committed itself to an architecture, so having justifications already prepared and readily available is a good thing.  

McConnell identifies a number of typical components of an architecture design.  It may be that some of the sections do not apply to your current system (for example, you may not have any focus on performance, or may not need to localise your application).  I'll tackle each component here, one at a time.

<h4>Program Organisation</h4>
This section defines the main modules of the system.  Each feature should be covered by at least one module, and each modules' reponsibilities should be well defined and loosely coupled.  Communication rules should be well defined.

<h4>Major Classes</h4>
The purpose of this section is to identify the responsibilities and interactions of the major classes in the system.  This will include some or all of class hierarchies, state transitions and object persistence.  

<h4>Data Design</h4>
All major files and table designs to be used should be documented in this section.  It should also document which module or class will be providing access to the data (and it should only be one, except for access classes providing persistence abstraction).

<h4>Business Rules</h4>
Identify your business rules here and describe their impact on the system's design.  For example, you may have a business rule that defines a "preferred customer" as one who has bought from you more than 10 times, or whose orders total more than £1,000.  Will this information be represented in the raw data, or calculated from the stored data?  If it is to be calculated, will it be done in the database (in a stored procedure) or in your application?

<h4>User Interface Design</h4>
This should be defined in the architecture only if it is not specified in the requirements.  It should describe how the system is to be modularised to allow major changes of UI.  This can be the part of the system that sees the most change, and can also be one of the hardest bits to change if not implemented with change in mind.  

<h4>Resource Management</h4>
Here you should describe your plan for managing external resources like database connections, threads and handles. It should also include memory management techniques, if appropriate to your development environment.

<h4>Security</h4>
It is arguable that all applications should define a threat model in this era of fast, permanent Internet connections.  Threat modelling is a whole book in itself, so I won't go into it in much detail here.  If you're after more information on application security from a developer's perspective, however, a good pointer is <a href="http://www.amazon.co.uk/Writing-Secure-Second-Michael-LeBlanc/dp/0735617228/" title="Writing Secure Code on Amazon.co.uk">Writing Secure Code</a> by Michael Howard and Steve Lipner, which could be considered the <em>Code Complete</em> of secure programming.  

This section should cover (amongst other things) buffers, approaches to handling untrusted data, encryption, the amount of detail exposed in error messages, and how in-memory secret data is handled.  

<h4>Performance</h4>
If performance is a concern for your application, then performance goals should have been specified in the requirements.  The section should include performance estimates, as well as identifying which areas are at risk of not meeting those estimates.  If certain areas require specific algorithms or data types, these should be documented here, along with the justifications for requiring them.  

<h4>Scalability</h4>
If scalability is not being designed for, this should be made explicit.  In all other cases, however, you need tackle how the system will address growth.  

<h4>Interoperability</h4>
Will your application share data or resources with other software?  If so, what data/resources, and which applications?  How is this to be achieved?

<h4>Internationalisation/Localisation</h4>
If you're working on an application for a small business, a school, or other similar organisation, internationalisation and localisation may not be concerns for you.  It is likely that public-facing applications for government, or applications written by large software companies, will be subject to internationalisation and localisation.  You need to identify whether these topics will impact your system or not, as they need to be baked into the architecture; it is very difficult indeed to bolt internationalisation and localisation support on afterwards.  

If this is a concern for your application, you will need to consider character sets, resource consumption, and how you will maintain and translate strings without touching code.  It will also impact your UI design.  

<h4>Input/Output</h4>
What are the reading schemes that your application will use?  Where are I/O errors detected: the field, record, stream, or file; or somewhere else entirely?

<h4>Error Processing</h4>
This section should define your techniques for handling exceptions and errors.  Most notably, will your error processing be corrective or detective, anticipative or reactive?  How will your system handle error propagation?  What conventions will it put in place for handling errors?  Will errors be handled at the point of detection, in an error-handling class, or passed up the call chain?  What responsibilities do classes have for their own data validation?  

McConnell also poses the question of the choice of exception handling mechanisms, i.e. will you use the built-in one, or your own?  I believe this is a sign of the book's age: the first edition was published in 1993, when there were few languages around with exception handling frameworks.  Even in 2004, when the second edition was published, languages such as C, without native exception handling support, were (and still are!) prevalent.  However, Java and latterly C# have come to dominate business applications, both sporting excellent exception handling support as part of the language/framework, so in my opinion there is no excuse for using your own exception handling mechanism in any modern language.  

<h4>Fault Tolerance</h4>
What techniques will your application employ to increase its fault-tolerance?  Is it even necessary?  Possibilities include back-off, auxiliary code and voting.

<h4>Architectural Feasibility</h4>
The architecture should show that the project is feasible.  This section should list the architect's concerns, and these should be addressed with investigations, such as prototypes and research.

<h4>Over-engineering</h4>
This section depends on the system, but effectively boils down to the question, "Should developers over-engineer or do the simplest thing that works?"

<h4>"Buy vs. Build" Decisions and Reuse Decisions</h4>
These sections are rather obvious: can you buy or download existing software to accomplish some of the tasks (e.g., logging, GUI controls, etc.)?  Can you reuse components from another application?  

Again, in my opinion, if there's a well-trusted third-party library that will achieve the required task, you should use this rather than rolling your own.  The one exception may be <a href="http://www.joelonsoftware.com/articles/fog0000000007.html" title="In Defense of Not-Invented-Here Syndrome">if the task is a core business function</a>.  

<h4>Change Strategy</h4>
This section should cover your techniques for anticipating and designing for changes.  By this I mean future developments of the system, not necessarily changes in requirements, etc., during the life of the existing project.  Techniques include version numbers, reserving fields for future use, etc.

<h4>General Architectural Quality</h4>
This section should describe a polished conceptual whole with few ad hoc additions.  The objectives of the system should be clearly stated, and the motivations for all major decisions should be described.  The architecture should be largely machine- and language-independent, and should be neither under-specified nor over-specified (remember the concept of gilding the lily).  

Risky areas should be identified, and the architecture should contain multiple views.  These views should be from the perspectives of different concepts in the system (e.g., data flow vs. user work flow), and possibly also for different consumers of the document.  For example, in my team at work, our Functional Specifications are written for ourselves, Test, Security, Globalisation and Technical Publications.  We provide appendices that group specific changes together to make it easier for these different departments to sift through.  

Finally, the architectural description should make sense to you, otherwise how can you implement it?

<h3>Duration and Effort</h3>
The amount of time you should spend on the upstream pre-requisites depends entirely on the needs of your project.  Generally speaking, you should expend 10-20% of the effort and 20-30% of the schedule on pre-requisites.  Remember, too, that detailed design is part of construction, and not part of the planning phase.  

Unstable requirements will take extra time to formulate and finalise.  For example, you might be working with a requirements analyst (on large, formal projects), or having to expend more of your own time ensuring requirements are well-defined (on smaller, informal projects).  However, on any-sized project, <strong>treat requirements work as its own project</strong>, and use a similar approach to requirements development as for architecture development.

<hr />
Here are the Key Points from the end of the chapter; as such they cover the <a href="http://www.codebork.com/coding/2009/05/21/code-complete-measure-once-cut-twice-part-1-importance-prerequisites.html" title="Code Complete: Measure Twice Cut Once (Part 1)">previous post</a> as well as this one.  They are paraphrased from McConnell's original wording as before.

<ul>
  <li>The overarching goal of preparing for construction is risk reduction.</li>
  <li>Attention to quality must be part of the process from beginning to end (unless you're not fussed about quality)</li>
  <li>Part of a programmer's job is to educate non-techies about the software development process.  This includes the importance of adequate preparation.</li>
  <li>The kind of project you're working on significantly affects the prerequisites.  Iterative vs. Sequential.</li>
  <li>Without a good problem definition, you might end up solving the wrong problem.</li>
  <li>Without good requirements work, you might have missed important details.  Requirements changes are 1-2 orders of magnitude more expensive during/after construction as before.</li>
  <li>Without a good architectural design, you might be solving the right problem the wrong way.  Architectural changes are an order of magnitude more expensive during/after construction as before.</li>
  <li>Understand what approach has been taken to the prerequisites, and choose your construction approach accordingly.</li>
</ul>
