---
layout: post
title: 'Code Complete: Measure Twice, Cut Once (Part 1 - The Importance of Prerequisites)'
author: alastairs
nid: 92
created: 1243537200
---
Any good carpenter, joiner, or other worker of materials will tell you to "measure twice, cut once".  This is a good philosophy to apply to life and your craft as a software engineer.  It implies attention to detail, efficiency and proper preparation; it results in "right first time" components and products, quality and reduced waste.  

So, getting your pre-requisites right is important.  There are different opportunities to emphasis quality: at the beginning of the project (planning and design), during the construction of the product and at the end of the project (testing).  During the construction phase, your only option is to build the product solidly, with quality materials and tools.  At the end of the project, when your only option is testing, you can't detect that your product is the wrong solution for the problem, or that it is the right product built in the wrong way.  Testing is only one part of quality assurance, and only ensure that the thing is fit for purpose.  

Therefore, the planning and design stages are your one opportunity to "get it right", and the cheapest opportunity to resolve any issues.  You can, and <em>should</em>, make sure you have the right project and the right plans, and ensure the design is fit for the product.  It's a risk reduction process.  As my Dad used to tell me, and as his boss (fittingly, in the construction industry) used to say, remember "The Seven Ps": <strong>Proper Preparation and Planning Prevents Piss-Poor Performance</strong>.
<!--break-->
Conversely, many programmers (myself included), rarely stick around to prepare ahead, and just dive right in.  Why is this?  Why don't programmers prepare ahead?  McConnell proposes a number of reasons:
<ol>
<li>They don't know how</li>
<li>They can't wait to start programming</li>
<li>Pressure from above</li>
</ol>

There are, of course, possible solutions to these, ranging from education to self-discpline to resistance (overt or covert).  The key thing, though, is to learn from your rushed jump-in-the-deep-end attempts.  Are the problems you experienced similar to other problems?  Could they have been foreseen?

McConnell also proposes his four-point "Utterly Compelling and Foolproof Argument for Doing Prerequisites Before Construction" (UCFADPBC, for those who prefer snappy initialisms).
<ol>
  <li><em>Appeal to logic</em>&nbsp;&nbsp;&nbsp;It makes sense to plan first, and the amount of planning that is sensible is directly proportional to the size of the project.  It also makes sense to design first; going down blind alleys wastes time, and time is money.</li>
  <li><em>Appeal to analogy</em>&nbsp;&nbsp;&nbsp;Building a house will require architectural drawings, blueprints, etc., before you can lay foundations.  You don't start decorating the Christmas tree before it's in the stand.  There are more :-)</li>
  <li><em>Appeal to data</em>&nbsp;&nbsp;&nbsp;McConnell references studies conducted by industry giants such as Hewlett-Packard, IBM, and others, that prove that it pays to do things right the first time, and that unnecessary changes are expensive. The table below illustrates the relative costs of fixing defects based on when they're introduced into the product, and when they're detected.  </li>
  <li><em>Boss-readiness Test</em>&nbsp;&nbsp;&nbsp;It's difficult to summarise this.  Essentially, "make sure your boss understands the importance of pre-requisites".  </li>
</ol>

<table summary="Average Cost of Fixing Defects Based on When They're Introduced and Detected" style="width: 100%">
  <caption style="font-weight: bold; font-style: italic;">Average Cost of Fixing Defects Based on When They're Introduced and Detected</caption>
  <thead style="background-color: #ccc;">
    <tr>
      <th></th>
      <th colspan="5">Time Detected</th>
    </tr>
  </thead>
  <tbody style="text-align: center;">
    <tr>
      <td><strong>Time Introduced</strong></td>
      <td>Requirements</td>
      <td>Architecture</td>
      <td>Construction</td>
      <td>System Test</td>
      <td>Post-Release</td>
    </tr>
    <tr>
      <td>Requirements</td>
      <td>1</td>
      <td>3</td>
      <td>5-10</td>
      <td>10</td>
      <td>10-100</td>
    </tr>
    <tr>
      <td>Architecture</td>
      <td>&mdash;</td>
      <td>1</td>
      <td>10</td>
      <td>15</td>
      <td>25-100</td>
    </tr>
    <tr>
      <td>Construction</td>
      <td>&mdash;</td>
      <td>&mdash;</td>
      <td>1</td>
      <td>10</td>
      <td>10-25</td>
    </tr>
  </tbody>
</table>

Different projects need different approaches; for example, <a href="http://www.fastcompany.com/magazine/06/writestuff.html?page=0,0" title="They Write the Right Stuff | Fast Company">the space shuttle software development process</a> is really very different from your favourite Agile methodology: the former is very sequential and very bureaucratic by necessity; the latter is fast, light-weight and very iterative.  McConnell mentions that projects generally aren't exclusively sequential or iterative, but are a mixture of the two.  For example, for a systematic change, you might do 80% up-front work; for an incremental change, it might only be 20% up-front work.  The choice of approach depends on the type of the project, the formality of the project, the technical environment, staff capabilities and the project's business goals.  McConnell provides the following comparison of when sequential and iterative methodologies might be appropriate:


<table style="width: 100%">
<thead style="background-color: #ccc">
  <tr>
    <th>Sequential</th>
    <th>Iterative</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Stable requirements</td>
    <td>Requirements are not well-understood</td>
  </tr>
  <tr>
    <td>Straightforward and well-understood design</td>
    <td>Design is complex, challenging, or both</td>
  </tr>
  <tr>
    <td>Dev team is familiar with the application's area</td>
    <td>Development team is unfamiliar with the application's area</td>
  </tr>
  <tr>
    <td>Project contains little risk</td>
    <td>Project has a lot of risk</td>
  </tr>
  <tr>
    <td>Long-term predictability is important</td>
    <td>Long-term predictability is not important</td>
  </tr>
  <tr>
    <td>Cost of changing requirements, design and code downstream is likely to be high</td>
    <td>Cost of changing requirements, design and code downstream is likely to be low</td>
  </tr>
</tbody>
</table>

The next post in this series will cover specific pre-requisite activities, such as requirements and architecture.
