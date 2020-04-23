---
layout: post
title: Test-Driving a Leap Year Calculator
author: alastairs
nid: 168
created: 1313346889
---
In preparation for [CAMDUG's first ever Dojo](http://codebork.com/2011/08/14/camdugs-first-ever-dojo.html) yesterday, I worked through the Leap Year kata, which I had intended to run in the first session, "Introduction to TDD".  I ended up swapping it out for the Roman Numerals kata, because I got through two iterations of the exercise in about 20 minutes.  However, I thought it would be useful to share the problem and my approaches to it with my readers.  
<!--break-->
The Problem
========

Like many kata, the problem is simply stated:

> Write a function that returns true or false depending on whether its input integer is a leap
> year or not.  A leap year is defined as one that is divisible by 4, but is not otherwise divisible by 
> 100 unless it is also divisible by 400.
>
> For example, 2001 is a typical common year and 1996 is a typical leap year, whereas 1900 is an
> atypical common year and 2000 is an atypical leap year.

First iteration
========

For my first iteration, I took an approach that I think is akin to Acceptance Test-Driven Development (ATDD).  That is to say, I took the four example years from the problem statement above and used them as my acceptance cases.  If all four acceptance tests pass, the system could be considered complete.  

[gist:1145099:acceptance_tests.cs]

[gist:1145099:implementation.cs]

I was left a bit uneasy with this approach, however: it seemed too easy, and I was only testing the examples given.  How did I know that, for example, 1984 would be considered a leap year and 1985 wouldn't?  What happens if -1984 is provided to the method?  What about 0, and other test cases I haven't even considered yet?

Second iteration
==========

I then deleted my first attempt; this is an important step when doing many iterations of a kata as it helps you to clear your mind of the details of previous solutions and look at the problem anew.  I tackled the problem with my more usual form of TDD in the second iteration, which is to say I wrote tests to exercise the method contract rather than fit the provided examples.  

My first test exercises the most basic rule of a leap year: if it is divisible by 4, then it is a leap year:

[gist:1145103:FirstTest.cs]

I went with the TDD approach of writing the simplest possible code to make the test pass:

[gist:1145103:FirstImpl.cs]

My second test exercises the inverse condition: if the year is not divisible by 4, then it is not a leap year:

[gist:1145103:SecondTest.cs]

And again, the simplest possible code to get this to pass is:

[gist:1145103:SecondImpl.cs]

I jumped a bit ahead with my third test, and ended up breaking my flow: I wrote a passing test.  That's a bad thing to do, because it means you have to really think hard about whether or not it is passing *for the right reason*.  If they're passing for the wrong reason and you leave it be, you're likely to run into problems later.  

[gist:1145103:ThirdTest.cs]

Because this test passes, there's no implementation step.  

Instead of writing a test for the situation where the year is divisible by 400, I should have written a test for the situation where the year is divisible by 100, which should return false:

[gist:1145103:FourthTest.cs]

And there is an associated implementation to write for this test:

[gist:1145103:FourthImpl.cs]

Aha!  Now test 3 fails.  It is hopefully now made clear why I should have written these last two tests the other way around: tests should only start to fail when you break something, which I have not done here.  Anyway, I'm now in the situation I would have been in if I had written the third and fourth tests the other way around, and I can write the implementation for the third test:

[gist:1145103:ThirdImpl.cs]

An integral part of the TDD workflow is refactoring: the rhythm that should be adopted is "Red, Green, Refactor".  My chosen refactoring was to pull out the small amount of logic testing whether a year was divisible by 100 into a new method called `IsCentury()`:

[gist:1145103:Refactor.cs]

At this point I decided to stop, but there are more refactorings to do (e.g., the code checking whether the year is divisible by 400, and perhaps the one for years divisible by 4 as well).  I felt more comfortable with this approach because I was testing the general rules rather than the specific examples.  I felt comfortable with the idea of extending this test suite and implementation to handle some of the edge cases (negative numbers, etc) I mentioned above.  I think the code for the second iteration is a fair bit cleaner than the first, even though there's only a couple of small refactorings between them.  

I'm interested to read feedback on both these approaches: am I missing something with ATDD?  Is my usual TDD approach flawed?  Am I refactoring early enough in my workflow?  
