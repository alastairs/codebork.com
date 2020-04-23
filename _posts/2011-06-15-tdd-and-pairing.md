---
layout: post
title: TDD and Pairing
author: alastairs
nid: 166
created: 1308171636
---
Today I spent most of the day pairing on a task with another developer. This is unusual for our company (the usual <span style="text-decoration: line-through">arguments</span> fears are raised) but we both found it a useful experience.  Here's what I learned today.  

As part of the pairing scenario, I suggested using a ping-pong test-first approach: 

  1. one developer writes a failing test and passes control to the other developer. Only one assertion is allowed per test method.
  2. the second developer then implements the code necessary to make the test pass, checks in to source control, writes a second failing test and passes control to the first developer
  3. the first developer writes an implementation, checks into source control, writes a failing test, and passes control to the second developer
  4. goto 2.

We found this a useful approach that allowed us both to build up a picture of the system as we developed it: both developers have to work out the tests and implementation, either by writing the failing test or by making the test pass.  I have since found (as is usually the case with TDD) that we have exceptionally high code coverage: 100% nearly everywhere.  

Progress was possibly a little slow given that I am a relative novice to TDD and my partner is even more so.  This is what I learned from the process, that I'm trying to feed back into my personal TDD style:

  1. **Think about the assertions first.**  This stops you getting bogged down in the implementation details of the test: you can go back and write them later, often with the help of ReSharper.  
  2. **Baby steps really are important.**  In the implementation of our first test, we jumped the gun a little bit implementing a List<T> as a data store for the class.  Strictly speaking, all we needed to pass the test was to return a number.  This seems like a silly implementation step to take: you know you're going to need to change it later and it doesn't do anything useful other than specifically pass that one single test.  However, when we came to write our second, third, and seventh tests, we found that all three passed coincidentally because we'd taken that leap too early.  
  3. **Baby steps are important for the tests too.**  A couple of times we tried to write a test that was too large for the progress we'd made so far.  Essentially, this was a test that said "fulfil the whole specification".  It is easier to come up with a sensible, single assertion in a smaller tests than it is in a larger or all-encompassing test.

* * * 

I'm really loving my job at the moment.  We're hiring, so why not come [work for us](http://grantadesign.com/jobs/index.htm)? We have [graduate roles](http://grantadesign.com/jobs/graduate-softwareengineers.htm), [senior roles](http://grantadesign.com/jobs/softwarec_jan11.htm), and [ASP.NET roles](http://grantadesign.com/jobs/asp.htm).  We have the widest range of teas in Cambridge.
