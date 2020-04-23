---
layout: post
title: 'Code Complete: Software Development Metaphors'
author: alastairs
nid: 90
created: 1242693913
---
Chapter 2 of <em>Code Complete</em> covers software development metaphors, critically evaluating a number of metaphors that have been proposed over the last thirty or so years, including code as writing, growing a system, system accretion, and software construction.
<!--break-->
Before we get on to the metaphors themselves, a concept of this chapter is the idea of "The Intellectual Toolbox".  This is also covered by <a href="http://www.amazon.co.uk/Pragmatic-Programmer-Andrew-Hunt/dp/020161622X/ref=sr_1_1?ie=UTF8&s=books&qid=1242693332&sr=8-1" title="Buy The Pragmatic Programmer from Amazon (UK)"><em>The Pragmatic Programmer</em></a>, and you will often hear programmers using tool-related metaphors, such as "when you have a hammer, everything looks like a nail".  The idea here is to build up your toolbox as you progress, just as any other craftsman would, but in place of hammers, chisels, routers and lathes, we have debugging tools, coding tools and testing tools: stack traces, protocol traces, design patterns, development methodologies, IDEs and productivity add-ins like ReSharper or CodeRush Refactor!, Mocking and Unit Testing frameworks.  Note that this represents a combination of intellectual (e.g., development methodologies) as well as "physical" tools (e.g., an IDE).  

So why do we, and why should we, use metaphors for understanding software development?  Well, metaphors are hugely important for furthering the understanding of complex ideas.  For example, the <a href="http://en.wikipedia.org/wiki/Dynamical_billiards" title="Dynamical billiards (Wikipedia)">billiard-ball model of gasses</a> and the <a href="http://en.wikipedia.org/wiki/Light#Wave_theory" title="Wave theory of light (Wikipedia)">wave theory of light</a> both propelled forward research, knowledge and understanding of the two concepts (dynamical systems and light).  In McConnell's words,

<blockquote>
The power of models is that they're vivid and can be grasped as conceptual wholes.
</blockquote>

They provide a heuristic abstraction to a complex problem: they're not precise models, but rather a bit of a guess.  Because of their heuristic nature, metaphors can lead you down false paths.  Perhaps the best example of this is again the wave theory of light.  Extending this metaphor to its logical conclusion led scientists to hunt for a medium that propagated light in the same way that air propagates sound, which they termed the "ether".  No one ever found the ether, precisely because it doesn't exist: the wave model of light was only half of the wave-particle duality that we now understand to be correct.  

<h3>Software Penmanship: Writing Code</h3>
This metaphor holds that software development is like writing a casual letter: you might make a number of drafts, screwing up and throwing away the unwanted ones.  This doesn't hold up for more than the smallest of projects, though.  Writing is usually a one-person activity, for example, whilst software development is frequently team-based.  Similarly, you can't change a letter once it's been posted; as we all know, software is only very rarely regarded as "complete".  Additionally, writing focusses on originality, whereas software development focusses on reusing ideas, code and test cases.  McConnell therefore dismisses the "writing" metaphor as too simple and rigid to be effective.  

<h3>Software Farming: Growing a System</h3>
The farming metaphor is similarly dismissed.  This metaphor holds that development should be like planting seeds and growing crops: you design, code and test a piece, and add to the system a little at a time.  This is, however, good technique described by a bad metaphor, and McConnell's advice is to retain the incremental approach and discard the "terrible" metaphor.  

The real weakness of this metaphor lies in the suggestion that you, the developer, have no control over how the software is developed.  Farming involves maintaining the ground in which the crops are grown, which may start out unsuitable for the crops you want to grow.  You're a slave to the weather: a particularly wet summer might destroy your entire crop of strawberries, or a dry summer kill off your wheat.  The best you can do is manage the factors affecting your crop, not control them.  This is not the same in software: you have direct control over the ground your software is built on, how it is built and, to an extent at least, what is built.  

<h3>Software Oyster Farming: System Accretion</h3>
McConnell believes that Oyster Farming is what people really mean when they mention the farming metaphor.  Oyster Farming, or software accretion, is the idea that software grows like a pearl inside a clam: it's added to layer by layer until the pearl is ripe for harvesting.  

The word "accretion" refers to growth, or some other increase in size, by a gradual external addition or inclusion.  This can be easily applied to software development: start with the simplest possible version that will run.  This forms the skeleton of the system, and slowly but surely the muscle and skin are added to the skeleton until the feature is completed.

As you might have already guessed, a lot of the Agile practices that have been developed in the last ten or fifteen years have their roots in the System Accretion metaphor.  And this is a good metaphor, too: it doesn't over-promise (like the software penmanship metaphor), nor is it easy to extend inappropriately (like the software farming metaphor).  

McConnell believes we can go one better, however.  

<h3>Software Construction: Building Software</h3>
The software construction metaphor has by far the most time and space devoted to it, perhaps unsurprisingly as it is McConnell's favoured metaphor.  He believes this to be a more useful metaphor than the "growing" or "writing" metaphors, as it is not only compatible with the idea of accretion, but also provides more detailed guidance.  Mistakes on small construction projects are easily rectified by tweaks or even starting again; however, mistakes on larger projects are harder to fix this way.

As with construction, labour is the single biggest cost to developing software.  In my case, I have a workstation-class PC, an aging desktop PC, two 19" monitors, a height-adjustable desk, a <a href="http://www.hermanmiller.com/mirra/" title="Herman Miller Mirra Chair homepage">Herman Miller Mirra chair</a>, an MSDN subscription, and a ReSharper licence.  This most likely totals something in the region of £5000, so the single biggest cost to developing software is my time and the time of my colleagues.  This is one reason the ReSharper licence is so important &mdash; it saves me a bunch of time, making me more productive.

I digress somewhat.  The point of highlighting the cost of labour is that, in construction, moving a wall six inches to the left is expensive only because of the time it takes, not because of the materials used.  This is magnified if the wall happens to be load-bearing.  The same applies to software: changing a report in an application is fairly trivial, but is time-consuming, particularly if the query (or other backing routine) needs changing.  Add to that the time required to test the change, and the simple job has cost you hundreds, if not thousands, of pounds.  

McConnell wraps up by returning to the concept of software metaphors.  He reminds us that metaphors are heuristic, and so are not mutually exclusive.  There can be some value in combining them if the circumstances require and allow for it.  Additionally, precisely because they are heuristics, they represent something "more like a searchlight than a road map".  He therefore recommends that they be used to give you insight into your problems and processes, and help you think about your programming activities and imagine better ways of doing things.

<hr />
<h3>Key Points</h3>
Quick-reference "Key Points" directly quoted from <em>Code Complete</em>:
<ul>
  <li>Metaphors are heuristics, not algorithms, and so can be a bit sloppy</li>
  <li>Metaphors help you understand the software-development process by relating it to other activities you already know about</li>
  <li>Some metaphors are better than others</li>
  <li>Treating software construction as similar to building construction suggest that careful preparation is needed and illuminates the difference between large and small projects</li>
  <li>Thinking of development practices as tools in a toolbox suggests that every programmer has several tools and no single tool is right for every job.  Choose the right tool for each problem.  </li>
  <li>Metaphors are not mutually exclusive.  Use the combination of metaphors that works best for you.</li>
</ul>
