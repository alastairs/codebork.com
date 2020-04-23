---
layout: post
title: Key Construction Decisions
author: alastairs
nid: 94
created: 1248447560
---
This is a relatively short post, covering the key construction decisions Steve McConnell highlights in his book <em>Code Complete</em>.
<!--break-->
The choice of programming language is an important one to get right and may be difficult to decide.  It's worth keeping in mind the team of programmers you have at your disposable, as programmers are more productive using a language familiar to them.  Equally, you should aim for a higher-level language if you can, as programmers working with lower-level languages like assembler or C tend to be less productive than those working in high-level languages.  Additionally, you will often find that the languages you have learned stay with you.  This has the unfortunate side-effect of manifesting itself in ugly ways, such as stretching C++ to be Fortran, or C# to be Java (something I've seen at work), so keep an eye out for this in your own code.  <a href="http://www.hanselman.com/" title="Scott Hanselman's Computer Zen">Scott Hanselman</a> has a great post on this exact topic, where <a href="http://www.hanselman.com/blog/BackToBasicsVarDim.aspx" title="Back to Basics: var != Dim">he tries to bend C# 3.0's <code language="csharp">var</code> keyword to be VB's <code language="vb">Dim</code> keyword</a>.

McConnell provides the following example ordering (high-level vs. low-level) of various programming languages, relative to C.  The list is by no means complete (note the under-representation of Functional languages, for example), but, generally speaking, if your language isn't on there, one very similar to it is (e.g., PHP => Perl, C# => Java):

<table style="width:100%;text-align: center">
  <caption style="caption-side:bottom;font-weight:bold;">Source: Adapted from Estimating Software Costs (Jones&nbsp;1998), Software Cost Estimation with Cocomo II (Boehm&nbsp;2000), and "An Empirical Comparison of Seven Programming Languages" (Prechelt&nbsp;2000)</caption>
  <thead style="font-weight: bold">
    <tr>
      <td>Language</td><td>Level Relative to C</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>C</td><td>1</td>
    </tr>
    <tr>
      <td>C++</td><td>2.5</td>
    </tr>
    <tr>
      <td>Fortran 95</td><td>2</td>
    </tr>
    <tr>
      <td>Java</td><td>2.5</td>
    </tr>
    <tr>
      <td>Perl</td><td>6</td>
    </tr>
    <tr>
      <td>Python</td><td>6</td>
    </tr>
    <tr>
      <td>Smalltalk</td><td>6</td>
    </tr>
    <tr>
      <td>Visual Basic</td><td>4.5</td>
    </tr> 
  </tbody>
</table>

McConnell then goes on to summarise the history of a number of languages, which I will not present here.  It's worth noting however, that McConnell's pr&eacute;cis is objective, and doesn't try to "push" or "sell" one language over another.  It's an interesting read.

Programming conventions are next to fall under McConnell's critical gaze, and he makes a good point that these conventions are important as a reflection of the system's conceptual integrity; they also help maintain it.  As such, the programming conventions to be used should be spelled out before work begins, as the details are too specific to be retrofitted.  

Last of all, McConnell points to something he calls "your location on the technology wave", because your position determines the richness of the available tools.  If, for example, you compare web development today, with all its frameworks (ASP.NET MVC, Rails, Django, CakePHP, to name just a few) and languages and developer tools, with web development in the early 2000s &mdash; let alone the 1990s! &mdash; you will see that in some ways it is less desirable to be a the front of the technology wave.  

"Late-wave" environments provide all manner of benefits, such as a number of programming language choices; comprehensive error checking; powerful debugging tools; automatic, reliable performance optimisation; (nearly) bug-free compilers; good documentation; integrated tools; and training.  In contrast, "early-wave" environments provide the exact opposite.  Programmers must invest time trying to figure out how the language works; working around bugs in the language; coping with primitive tools; fixing code broken by new compiler/framework releases; and juggling multiple tools.

That's not to say you should avoid early-wave environments, however, as working in this space will often place you ahead of the competition.  For example, Lotus 123, MS Word, and Amazon were all built in this space.  And of course, the advice dispensed by <em>Code Complete</em> will help even more in primitive environments!  Most of the important principles in <em>Code Complete</em> depend not on specific languages, but on the way you use them.  

So, in closing, the Key Points to take away from this post are:
<ul> 
  <li>Every programming Language has its strengths and weaknesses.  Be aware of those of your chosen language.</li>
  <li>Establish conventions before you begin programming, as it's virtually impossible to make code match them later.</li>
  <li>More construction practices exist than can be used on your project.  Consciously choose the practices best-suited to your project.</li>
  <li>Are the programming practices you're using a response to the language, or controlled by it?</li>
  <li>Your position on the technology wave determines what approaches will be effective, or even possible.  Identify your current position and alter your plans and expectations accordingly.</li>
</ul>

<hr />

<h3>References</h3>
Boehm, Barry, et al. (2000) <em>Software Cost Estimation with Cocomo II.</em> Boston, MA: Addison-Wesley
Jones, Capers. (1998) <em>Estimating Software Costs.</em> New York, NY: McGraw-Hill
Prechelt, Lutz. (2000) "An Empirical Comparison of Seven Programming Languages", <em>IEEE Computer</em>, <strong>October 2000</strong> 23-29.
