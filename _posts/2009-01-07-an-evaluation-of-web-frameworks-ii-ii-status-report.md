---
layout: post
title: 'An Evaluation of Web Frameworks II.ii: Status Report'
author: alastairs
nid: 65
created: 1231339305
---
It's been a little while since I made any progress on this little project of mine, due to the <a href="http://www.alastairsmith.me.uk/random-stuff/2009/01/03/downtime.html" title="Downtime">downtime</a> I suffered throughout December.  I couldn't get access to my virtual machine server, so I wasn't able to restart the VM hosting my blog and my Subversion repositories; everything went down together.  

As such, it's probably time for an update on where I've got to so far.
<!--break-->
I spent a fair bit of time getting the repository and the project set up correctly, including much shifting around of stuff, playing around with <a href="http://www.alastairsmith.me.uk/coding/2008/11/22/escaping-svnexternals.html">svn:externals</a>, setting up <a href="http://ccnet.thoughtworks.com/" title="CruiseControl.NET Homepage">CruiseControl.NET</a> for automated builds and testing, pulling out some of the default guff from the ASP.NET MVC project (and, of course, working out what was needed and what wasn't), etc., etc., etc., ad nauseam.  Over and above all that, however, I have spent some time defining my models.  I have classes representing Posts, Comments and Users, and I've made a start on my Controllers too.  The controllers house most of the logic, and so are the most complicated part to develop.  

I have already discovered, for example, through the few automated tests I already have, that I need to factor out my database logic into supporting code.  The tests for saving a post run fine on my development machine, but fail on my build server.  A bit of <a href="http://www.alastairsmith.me.uk/coding/2008/09/13/test-driven-development.html" title="Test-Driven Development">TDD</a>, partnered nicely with <a href="http://www.alastairsmith.me.uk/coding/2008/08/24/nmock-framework.html" title="NMock Framework">NMock</a> should (hopefully!) give me a decent data access layer that I can later mock again using NMock in my unit tests for the Controllers.  I also need to get myself more into the TDD mindset of writing the tests first and then writing the code to fix the tests.  

Discipline is everything when practising a new methodology.  Hopefully I'll have another post for this series in a few days or so.  We'll see!
