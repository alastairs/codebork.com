---
layout: post
title: CAMDUG's first ever Dojo
author: alastairs
nid: 170
created: 1313328677
---
Yesterday, [CAMDUG, the Cambridge Developer's Group](http://www.camdug/), ran its first coding dojo generously hosted by my employer [Granta Design](http://www.grantadesign.com/jobs/) (we're hiring!).  Rooted in the principles of [Software Craftsmanship](http://manifesto.softwarecraftsmanship.org/), dojos bring developers together to sharpen their Test-Driven Development and Design (TDD) saws.  Like musicians practising their scales, kata are [exercises for developers](http://codebork.com/coding/2011/05/15/code-kata-scales-development.html) to instil muscle memory.  

CAMDUG was joined for the first time by members of the [London Software Craftsmanship Community](http://www.meetup.com/london-software-craftsmanship/) including one of its co-founders, Sandro Mancuso who was gracious enough to cross-promote the event to his own members.  Thanks Sandro!  The mix was approximately 50:50 which brought us an interesting diversity of primary languages too: ~50% Java, ~30% C#, ~10% Python and ~10% Haskell.  This was particularly good for CAMDUG as we originally started out as the Cambridge .NET User's Group and expanded the remit about eighteen months ago.  

<!--break-->

First-session: Introduction to TDD
=====================

I composed the day from four sessions, with a good discussion session over lunch (generously provided by [Red Gate](http://j.mp/rickyleeks/)). The first session was an intended to be an introductory session, but given that the vast majority of people in the room were familiar with the principles of TDD I was able to skip much of that content.  Instead, we got straight into the first kata, which was to convert numbers into [Roman Numerals](http://en.wikipedia.org/wiki/Roman_Numerals).  Two iterations on this problem were completed, with people deleting their code and swapping pairs between them. There were some interesting approaches to the problem: some people tackled it with sequential numbers from 1 and tackling each new case as it came along, before introducing some random higher numbers to exercise trickier facets of the problem; others tackled the simple cases (1, 5, 10, 50, 100, 500, 1000) before moving onto trickier numbers like 2, 18, etc.  Additionally, some people struggled with understanding the domain of the problem (although seemed to grok the problem as a whole) and ended up spending one iteration of this session on what felt to me like Big Design Up Front.  

Second Session: Cementing Your Knowledge
===========================

The second session was intended to be more challenging, and so I set the problem of the game of Minesweeper to be attacked in one paired iteration.  The aim of the kata is to generate a hint-field from a description of a Minesweeper board.  The hint-field places the mines on the board, and fills in all the other squares with a number indicating how many mines around found in the squares immediately surrounding that square.  The kata describes some sample input in the following format

    4 3
    *...
    ..*.
    ....

This states that the board is 4 squares wide by 3 squares high; mines are represented as asterisks and empty squares are represented as dots.  That input should then be converted into the following output:

    *211
    12*1
    0111

Even allowing the whole hour for this exercise wasn't long enough for people to make a really substantial amount of progress, but there were a few pairs that did make significant progress on the problem.  Lunch arrived toward the end of this session, so I wasn't able to do the same kind of round-up of approaches as I did the first.

Third Session: TDD in the Real World
======================

After some great discussions over some tasty food, we started back after lunch with a more "real-world" problem than we had been approaching in the morning: developing a simple bank account system.  The initial exercise was to implement Deposit, Withdraw and Check Balance behaviours.  If pairs completed those three behaviours before the end of the session, they were free to implement further behaviours of their choice such as Transfer, Print Statement, etc.  I think only one or two pairs did in fact make it onto this stage in the hour, so this was a slightly better-judged session time-wise.  Interestingly, one or two pairs developed their system under test with a full set of green tests that sometimes only tested the happy path.  As I was doing my rounds in this session, I prompted a few people to consider the situation where a negative amount of money was deposited into the account.  Another interesting observation was the number of people using ints to represent quantities of money and this led me to consider an alternative approach to my default (using floats to denominate pounds and pence): using an unsigned int or long to represent the amount in pence.  This removes problems caused by rounding errors, but of course limits you to only a single currency (because the conversion to sterling may result in fractional pence).  

Fourth Session: An Objective Work-Out
========================

This was a more advanced session, and the highlight of the day for some (including me).  For this exercise, we kept the same pairs and same code from the previous session and the first aim was to complete a refactoring exercise.  The exercise was to refactor the system to obey the [nine rules of object calisthenics, as defined by Jeff Bay](http://j.mp/objectcalisthenics):

1. One level of indentation per method
2. Don’t use the ELSE keyword 
3. Wrap all primitives and strings
4. First class collections
5. One dot per line
6. Don’t abbreviate
7. Keep all entities small
8. No classes with more than two instance variables
9. No getters/setters/properties

(Explanations of the rules are provided in the [paper](http://www.cs.helsinki.fi/u/luontola/tdd-2009/ext/ObjectCalisthenics.pdf), which is a short but very interesting read.)  These rules are intentionally very strict and are designed to lead you into writing highly object-oriented code.

Some of these rules were easier to follow than others; as we'll see shortly, rule 9 was the hardest to follow, but other than that different pairs struggled with different rules.  Rule 6 was declared the easiest to follow.

Unanimously, the quantities of money being handled, previously handled as ints or doubles, were wrapped up into a Money class.  One question that was immediately thrown up was how to implement the Check Balance behaviour without using a getter.  This is indeed a tricky question, and there are a number of approaches to solving it: some wrapped the concept of a Balance into a separate class (arguing, rightly, that a Balance can be negative whilst Money cannot), although this threw up a few new problems to solve; others calculated the balance based on a list of transactions.  

Post-Close Session: Pub
===============

We retired to The Earl of Derby afterwards for a drink and a discussion over the day.  One particularly fascinating discussion surround the interplay between the ninth rule of the object calisthenics exercise (no getters and setters) and the [Single Responsibility Principle (SRP)](http://codebork.com/2009/02/18/solid-principles-ood.html#SRP): how do you implement a statement printer obeying the SRP and without using getters?  You either need a class that handles printing of a statement (to obey the SRP) that retrieves information about the statement via getters, or you need to violate the SRP and require that statements, transactions and money all know how to print themselves.  Using data-transfer objects (DTOs) or ViewModel objects doesn't help at all either, because you would need to violate the ninth rule twice in order to use them: once on the Model objects to create the DTOs/ViewModels, and once to print the DTOs/ViewModels in the printer object.  

I had seen on Twitter that Sandro was reading *Game of Thrones* (as am I), so we also spent a bit of time talking Sci-Fi and Fantasy :-)  

Wrap-Up
=====

I wil be running a similar day at work in the near future, so this turned out to be really useful in working out what to do and what not to do next time.  

I think down to my inexperience in running this kind of event (it was my first as organiser/facilitator) and some nerves on the day, I started one or two of the sessions before everyone had completely grokked the task at hand, which meant that they either didn't get as much out of that session as they might have, or that I had to do the rounds and ensure everyone was kicking off ok.  

When I got home, [this post](http://blog.coderetreat.com/on-the-role-of-the-coderetreat-facilitator) popped up in my RSS reader, which would have been a useful read beforehand, so I will digest that before the next.  

Some administrivia bits fell through, as well; I wasn't able to buy the appropriate labels for Meetup's name badges, so we had to do a quick round-room introduction at the start of the day.  This was doubly disappointing for me, as I had intended to put a mark on each name badge indicating what languages the attendee was comfortable using to make pairing a little easier.  That said, we didn't seem to have any problems getting the pairs sorted relatively quickly.  Additionally, we weren't able to provide an internet connection to attendees, but this didn't hinder the day as much as it might have done at other types of event.  

It was *really* difficult keeping to time; we started five minutes late and although we got back on track after lunch we ended up finishing the afternoon ~30 minutes over time.  At future events of this kind, I will need to allow more time in the schedule for the discussions.  

I also need to remember that The Flying Pig doesn't open until at least 6pm on a Saturday.

Slides
====

The slides I used during the day, including some simple descriptions of the kata, are [available for download](http://www.codebork.com/sites/default/files/CAMDUG%20Dojo%20Day.pptx).
