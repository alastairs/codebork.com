---
layout: post
title: 'Public Service Announcement: Io and Prolog on Mac OS X'
author: alastairs
nid: 172
created: 1313940881
excerpt: !ruby/string:Sequel::SQL::Blob "I encountered a couple of issues moving on
  from the Ruby chapter of Bruce Tate's book *Seven Languages in Seven Weeks*:\r\n\r\n1.
  Io does not currently compile,\r\n2. Prolog installs to an odd location.  "
---
A quick public service announcement for anyone else currently working through *Seven Languages in Seven Weeks* on a Mac.  

Chapter 3's language, [Io](http://www.iolanguage.com/), does not currently compile on Mac OS X if you attempt installation via [Homebrew](http://mxcl.github.com/homebrew/).  [This patch](https://github.com/stevedekorte/io/pull/140) should fix it once it has been pulled into Io master. 

Chapter 4's language, Prolog, can be installed from the [GNU Prolog web site](http://www.gprolog.org/#download).  It installs to an odd location, `/opt/local/bin`, which you will need to add to your path to get it working properly.  

Hope that helps someone else out there!
