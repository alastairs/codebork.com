---
layout: post
title: 'Code Complete: Design in Construction (Part 1 - Design Challenges)'
author: alastairs
nid: 96
created: 1244746800
excerpt: !ruby/string:Sequel::SQL::Blob "Chapter 5 of <em>Code Complete</em> covers
  the concept of Design in software construction.  This is a pretty weighty chapter,
  so I'm going to tackle it in a mini-series of posts.  Here I cover McConnell's description
  of the design challenges, including why it's so hard to get right.  \r\n\r\nThis
  post is a something of a bite-size chunk, and hopefully it'll provide a measure
  of breathing space between two large posts.\r\n\r\n[img_assist|nid=98|title=Design
  can be a wicked problem|desc=|link=none|align=center|width=400|height=292]\r\n"
---

McConnell states that design links the requirements phase to coding and debugging: it is an intermediary representation of real-world issues and concepts.  As such, good design is always useful, but often it is indispensible; this is particularly true with the ever-increasing level of complexity in computer software.  

McConnell believes that design is a good example of a "wicked" problem, which Rittel and Webber (1973) describe thus:
<blockquote>
"One that could be clearly defined only by solving it, or by solving part of it"
</blockquote>
The upshot of this is that you have to "solve" the problem once in order to clearly define it.  You then go ahead and solve it again &mdash; and you do so better this time, given your better understanding of the problem &mdash; which results in a better problem definition.  This implies that design is an heuristic process, and possibly inherently iterative also.  

McConnell identifies the <a href="http://en.wikipedia.org/wiki/Tacoma_Narrows_Bridge_(1940)" title="Wikipedia article on the Tacoma Narrows Bridge collapse in 1940">Tacoma Narrows Bridge collapse in 1940</a> as a real-world example of a wicked problem.  A more up-to-date example that is arguably more relevant to my readership is that of <a href="http://en.wikipedia.org/wiki/London_Millennium_Bridge" title="Wikipedia article on the London Millennium Bridge">London's Millennium Bridge</a>: just three days after it was opened, the Millennium Bridge had to be closed because it wobbled.  The wobble arose from "unexpected lateral vibration" created by the pedestrians using the bridge; whilst bridges are designed to account for resonance caused by vertical loads, it was not known until the structure was completed that the problem of lateral vibration would need to be taken into consideration too.  It was particularly problematic at opening, because of the popularity of the structure: it was carrying up 2,000 people at any one moment, vastly increasing the amplitude of the lateral vibrations.  

[img_assist|nid=98|title=London's Millennium Bridge|desc=View from the Tate Modern gallery|link=none|align=center|width=600|height=438]

This is, by and large, something from which University courses will shelter you: if the requirements for a piece of coursework were to change constantly, the lecturer wouldn't be able to effectively assess your solutions.  The "wickedness" of the design problem is therefore vastly reduced for course assignments.  

McConnell also explains that even though design produces a tidy result, it is implicitly a sloppy process.  As you work towards a design, you will inevitably make a lot of mistakes and be led up a number of blind alleys.  This is, however, the whole point of the design process, and it is much safer to make those mistakes here than when you have already got code seared into the architecture.  Corollary: it is much harder to know when your design is "good enough", and it can sometimes be difficult to stop tinkering.  The Agile principle of YAGNI (You Ain't Gonna Need It) provides a useful counterbalance to this instinct.  

Design is all about trade-offs and priorities.  You will have to reach a compromise over competing design characteristics.  We recently had this scenario at work: there were two different approaches to solving one particular design problem, one that focussed on performance and one that might damage performance to an unknown degree but resulted in cleaner and more maintainable code.  The argument against the former was that it was premature optimisation; the argument for it was that performance is a key quality metric of our component and so we should not introduce anything that would damage that.  

Design invariably involves restrictions, and sometimes deliberate constraints are required.  One of the clearest signals that your design is not suitably constrained is the notion of "feature creep", where new requirements and features are added to the design on an on-going basis.  This invariably endangers projects, and can sometimes kill them altogether.  

Design is a non-deterministic process, in that there is no single right answer: there is always more than one way to skin a cat.  It is also an emergent process, in that it doesn't spring, fully-formed, from someone's brain.  The best way to achieve a good design is to do so iteratively, as if you were drafting a story, a blog post, or some other bit of written communication: produce multiple drafts.  Turn the wickedness of the problem to your advantage: solve it once, take what you learned from the process and solution and then solve it again, better.  Lather; rinse; repeat as needed.  

<hr />
<h3>References</h3>
Rittel, H. and Webber, M. (1973) "Dilemmas in a General Theory of Planning." <i>Policy Sciences</i> <b>4</b> 155-69
