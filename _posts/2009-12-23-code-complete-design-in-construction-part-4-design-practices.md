---
layout: post
title: 'Code Complete: Design in Construction (Part 4 - Design Practices)'
author: alastairs
nid: 108
created: 1261583696
---
Wow, it's been quite a while since I updated my <em>Code Complete</em> series, and I've got quite the backlog to wade through now!  Looking at the last save date on this post, it's been sat around for three months waiting to be written, so I'm sorry for being so slack, and I'll get on with writing it now...

This post covers some key design practices, and is the last post on Chapter 5, Design in Construction.
<!--break-->
The simplest design practice is to <strong>iterate</strong> your designs.  Your second attempt at solving a problem is nearly always better than the first: this is somewhat because <a href="http://www.codebork.com/coding/2009/06/11/code-complete-design-construction-part-1-design-challenges.html" title="Code Complete: Design in Construction (Part 1 - Design Challenges)">design is an example of a "wicked problem"</a>, i.e., one that can be clearly defined by solving it in whole or part.  Note also that iteration requires the critical appraisal of the design after each iteration, allowing for kinks, mistakes, and omissions to be corrected.  

Another option available to you in design is the notion of divide and conquer.  This is a useful tool for decomposing a complex system into different areas of concern, and will help introduce greater modularity into your system, making it more loosely-coupled.  All good stuff.  If you run into a dead end when dividing your system, fence it off and start a new iteration using the knowledge that you've gained from the first attempt.

Useful with divide and conquer are top-down and bottom-up decomposition.  Top-down decomposition starts at a high level of abstraction, drilling down into the detail in successive applications of the technique; you should keep decomposing until the next level is "obvious" and therefore easier to code than decompose further.  The advantage of this approach is that it makes complex systems easier to deal with: it introduces fewer details at any given time, and allows you to defer construction details until it is most appropriate to deal with them.  

Bottom-up decomposition works in the opposite direction, starting with the specifics and building successive generalisations on top of them.  This is useful when the top-level abstraction is poorly-defined or -understood; sometimes it's just easier to start with the specifics.  It also provides a couple of advantages in construction: utility functionality is identified earlier (thereby producing a compact and well-factored design); and code reuse becomes more obvious and easier to consider.  However, it is very hard to use exclusively, and sometimes you can't build a coherent system from the pieces identified.  As a result, you should bear in mind the following tips when using bottom-up design:
<ul>
  <li>Keep asking yourself what you <em>know</em> the system should do</li>
  <li>Identify concrete objects and responsibilities from that question</li>
  <li>Identify common objects and group them using subsystem organisation, packages, composition within objects or inheritance (whichever is most appropriate for the scenario).</li>
  <li>Continue with the next level up, or skip to the top and try to work down.</li>
</ul>

Sometimes, however, you just have to try something out to know if it will work, and this is where experimental prototyping has a role to play.  It can be very easy to slip into making a polished prototype, or at the very least, something more than that which is most definitely must be, which is <strong>the absolute minimum required <em>throwaway</em> code.</strong>  For example, when assessing database performance, create the right number of tables called Table1, Table2, etc., with the right number of columns each called Column1, Column2, &hellip; , and fill the rows with <em>junk</em> data.  In order to achieve the best results from prototyping, the question forming the basis of the scenario must be specific.  "Will X work?" is not specific enough; "Will X support Y under assumption Z" is.  Finally, the code created must be throwaway; if there is any belief that it will be re-used, the developer(s) will end up producing an implementation and not a prototype.  

Collaborative design practices are very useful tools to keep on your belt; the value of an extra pair of eyes is not to be underestimated.  There are many ways of utilising a collaborative approach ranging from the informal (bouncing ideas around with a co-worker, whiteboarding) to the formal (pair programming, formal inspections).  If you don't have a team to collaborate with, it's possible to get some of the benefits of the collaborative process by using self-reviews: produce a design, put it away for a week, and then come back and appraise it.  You will be looking at it afresh, and will be able to evaluate it as another might.  

McConnell poses the important question of how much design is sufficient for a project in this chapter, and answers it with the following table:

<table style="text-align: center">
  <thead style="font-weight: bold; border-top: 2pt solid silver; border-bottom: 2pt solid silver">
    <td style="text-align: left; border-right: 1pt solid silver">Factor</td>
    <td style="border-right: 1pt solid silver">Level of Detail Needed in Design Before Construction</td>
    <td>Documentation Formality</td>
  </thead>
  <tbody>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Design/construction team has deep experience</td>
      <td style="border-right: 1pt solid silver">Low Detail</td>
      <td>Low Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Design/construction team has deep experience but is inexperienced in the application's area</td>
      <td style="border-right: 1pt solid silver">Medium Detail</td>
      <td>Medium Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Design/construction team is inexperienced</td>
      <td style="border-right: 1pt solid silver">Medium to High Detail</td>
      <td>Low-Medium Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Design/construction team has moderate-to-high turnover</td>
      <td style="border-right: 1pt solid silver">Medium Detail</td>
      <td>-</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Application is safety-critical</td>
      <td style="border-right: 1pt solid silver">High Detail</td>
      <td>High Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Application is mission-critical</td>
      <td style="border-right: 1pt solid silver">Medium Detail</td>
      <td>Medium-High Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Project is small</td>
      <td style="border-right: 1pt solid silver">Low Detail</td>
      <td>Low Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Project is large</td>
      <td style="border-right: 1pt solid silver">Medium Detail</td>
      <td>Medium Formality</td>
    </tr>
    <tr style="border-bottom: 1pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Software is expected to have a short lifetime
(weeks or months)</td>
      <td style="border-right: 1pt solid silver">Low Detail</td>
      <td>Low Formality</td>
    </tr>
    <tr style="border-bottom: 2pt solid silver">
      <td style="text-align: left; border-right: 1pt solid silver">Software is expected to have a long lifetime
(months or years)</td>
      <td style="border-right: 1pt solid silver">Medium Detail</td>
      <td>Medium Formality</td>
    </tr>
  </tbody>
</table>

There are a couple of caveats, of course.  First, the terms "Medium detail", "low formality", etc., are a little vague (particularly the documentation measures), so require guess-work (ideally grounded in experience) to decide what constitutes "high detail".  Additionally, two or more of these factors might be relevant to your project, and sometimes they may contract each other (e.g., a small, long-lived, mission-critical application).  In these scenarios, you need to use your judgement to decide how far to go.  

Finally, McConnell describes ways of capturing your design work.  These range from using formal design documentation methods, such as Class-Responsibility-Collaboration Cards (CRC cards, produced using index cards, listing the class name, its responsibilities and classes that co-operate with it) through to using wikis to capture design discussions and decisions, and inserting design documentation into the code itself (e.g., using file/class comments, which are particularly powerful if coupled with a comment-parsing system such as JavaDoc or Doxygen).  Other suggestions include writing email summaries to the team and archiving them publicly; using a digital camera to photograph whiteboard drawings; using UML diagrams at appropriate levels of detail; and saving design flip charts (which can be used instead of re-writing all that information into a formal document).
