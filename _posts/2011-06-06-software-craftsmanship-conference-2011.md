---
layout: post
title: Software Craftsmanship Conference 2011
author: alastairs
nid: 158
created: 1307400208
excerpt: !ruby/string:Sequel::SQL::Blob "At the end of May, I attended the Software
  Craftsmanship Conference 2011 at Bletchley Park, near Milton Keynes.  As with the
  2010 conference held in October this event proved to be well worth attending, although
  sadly (and counterintuitively) the weather didn't really allow for tours of the
  Park this time.  Thanks to Jason Gorman, the speakers, and the folks at Bletchley
  Park for organising and contributing to the event, and to the volunteers at Bletchley
  Park in particular for braving the elements to offer us tours of the historic site.
  \ \r\n\r\nRead on for a summary of my day..."
---
Despite some initial reservations about the sessions on offer at this year's Software Craftsmanship conference, I found the day interesting and useful.  It was good to see some familiar faces from last year's event as well as some of the leading lights in the dev community such as [Gojko Adzic](http://gojko.net/ "Gojko's blog") and Sandro Mancuso, convenor of the London Software Craftsmanship Community.  There was an interesting mix of sessions and, importantly, session formats, with my day being neatly balanced between coding and discussion sessions.  Coding sessions were invariably pair-programmed using some form of <abbr title="Test-Driven Development">TDD</abbr> methodology.

### _How Object Oriented Are You Feeling Today?_  Krzysztof Jelski ###

[Session overview:](http://vimeo.com/23404983)
<iframe src="http://player.vimeo.com/video/23404983?title=0&amp;byline=0&amp;portrait=0" width="400" height="320" frameborder="0"></iframe>

This was, I think, my favourite session of the day, and a great way to get into the event as a whole.  The session is based around Jeff Bay's Object Calisthenics which proposes the following nine rules for writing better Object-Oriented Code:

1. Use only one level of indentation per method
2. Don’t use the else keyword
3. Wrap all primitives and strings
4. Use only one dot per line
5. Don’t abbreviate
6. Keep all entities small
7. Don’t use any classes with more than two instance variables
8. Use first-class collections
9. Don’t use any getters/setters/properties

The rules are quite often extreme, and are certainly artificial, _but_ they are brilliant in small self-contained exercises such as the bank account scenario we worked on during the session.  They really do help you get into the mindset of object orientation when procedural code can feel more natural.  

Some of the rules are easier to follow than others: rule 6 falls out of some of the others, such as rule 3; rule 5 is simply a rule for good naming that I follow during daily development anyway.  Rule 9 was a really tough one to follow, and I think our compliance with it was a bit suspect (working in C#, we used a method called `GetCurrentBalance()` in place of a property `CurrentBalance`).  Rule 3 was not difficult to follow per se, but it did increase the amount of code enormously and made you second-guess just how far you followed it.  For example, in the bank account exercise we wrapped the balance, which might normally have been represented as a decimal, into an object `Money`; however, this in turn used decimals in its implementation which made me wonder whether we should have wrapped that as well!  

Having got into the OO mindset during this session, I found some of the ideas I picked up during it were easily applicable in the CyberDojo session in which I participated towards the end of the day.  There is real value in practising these rules in a small exercise, viewing the über-OO code that you get out of it, and following the patterns of implementation you see in the result in your everyday work.  

My one "complaint" about this session is that it was too short!

### _Enhancing Legacy Test Suites_ Christian Horsdal ###

[Session overview:](http://www.youtube.com/watch?v=lz_cBR8Mg0E)
<iframe width="425" height="349" src="http://www.youtube.com/embed/lz_cBR8Mg0E" frameborder="0" allowfullscreen></iframe>

This session took me a little by surprise: I found it was a discussion-based session when I was expecting a coding session.  That'll teach me to read the session summaries and watch the overview videos beforehand...  Anyway, the premise of the session is that even though some code bases can have extensive suites of unit tests, the quality of the tests may be low (this is something I can sympathise with).  Christian went through a few pointers of what could be considered a poor-quality test (tests named Test1, assertions that test little or nothing, tests that test the implementation rather than the contract, etc.) and then fired up Visual Studio 2010 and the Nerd Dinner application produced by [Scott Hanselman](http://www.hanselman.com) and others as a tutorial for ASP.NET MVC (v1.0, so it's a couple of years old now) and running live at http://www.nerddinner.com/.  We then spent the better part of an hour <span style="text-decoration: line-through">picking apart</span> critiquing the tests in the application.  The most interesting thing for me was how obvious it was to people in the room that the tests had been written after the code and not beforehand as an integral part of the development workflow, and the best way to enhance this suite of tests was to re-write tests as you came to them.  

Christian's own write-up of his session is [here](http://horsdal.blogspot.com/2011/05/take-away-points-from-my-software.html).

### _CyberDojo_ Jon Jagger ###

[Session Overview:](http://vimeo.com/15104374)
<iframe src="http://player.vimeo.com/video/15104374?title=0&amp;byline=0&amp;portrait=0" width="400" height="330" frameborder="0"></iframe>

This was another fun coding session, based around Jon's CyberDojo app which you can try for yourself at http://www.cyber-dojo.com/.  The idea behind the app is to practice coding in a test-driven manner on a simple solution.  The idea is not to finish the exercise on the first (or subsequent) attempt, but instead to improve your coding skills through deliberate, repeated practice.  It was a useful introductory session to the app and to this style of practice, but didn't go much further than this.  When running the second iteration in Java (the first iteration was in Ruby and consequently was... difficult), I was able to apply some of the ideas learned in the morning's Object Calisthenics session to improve the OO-ness of the solution.  

### _Personal Codes Of Conduct_ Matt Williams ###

[Session overview:](http://www.youtube.com/watch?v=szf68J4bH38)
<iframe width="560" height="349" src="http://www.youtube.com/embed/szf68J4bH38" frameborder="0" allowfullscreen></iframe>

Matt's session was one of the more interesting discussions on the software industry I've been in for a while.  Matt's idea was to try to take some lessons from medicine and apply them to software, and in the main I think he succeeded.  His idea was to take some of the principles of the Code of Conduct set out by the General Medical Council and translate it into something relevant to the software industry; he has more recently been using this as his own personal Code of Conduct, and expects his colleagues and customers to hold him to it.  The following discussion session revolved around the usual Craftsmanship topics of quality and process, and knowingly side-stepped that of certification.  One area I would have liked to have seen explored in more detail is that of reputation, which was mentioned by one participant but was not really developed for some reason.  Considering the analogous situation of cowboy builders, you quickly come to realise that reputation is paramount to securing a good builder: people tend to re-use tradesmen over a large number of years based on previous positive experiences, good personal recommendations, etc.  If you pick someone new out of the Yellow Pages each time, or respond to a leaflet through your door, you're guaranteed to have at least one bad experience.  Part of the problem appears to be in educating our potential customers in the value of demanding good quality, well-tested, highly-covered code when this quite often falls prey to the requirement of "and I want it yesterday!"  

### Conclusion ###

I had a great time at SC2011, and am already looking forward to SC2012.  I hope that this summary has convinced you that you should be there too!  
