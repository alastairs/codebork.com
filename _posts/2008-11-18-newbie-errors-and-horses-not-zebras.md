---
layout: post
title: Newbie Errors, and Horses, not Zebras
author: alastairs
nid: 56
created: 1227048816
---
I've been doing a lot more JavaScript development at work over the last few months, working on a site that is AJAX'd up to the hilt.  Everything's done with fancy jQuery effects and asynchronous calls back to the web server.  The page in the browser literally never reloads.  

Something that caught me out today: there's no <code language="java">String.equals(String)</code> in JavaScript.  My first thought was "what kind of half-baked language doesn't provide an equals method for strings?!".  Then it occurred to me that select isn't broken (or "Horses, not Zebras").  Hell, I've been doing Java and C# for so long now, that I'd forgotten that most times you can just do <code language="javascript">"string" == "string"</code> and you don't <em>need</em> <code language="java">.equals()</code>.  

"Select isn't broken" is Tip No. 26 from <a href="http://www.pragprog.com/the-pragmatic-programmer">The Pragmatic Programmer</a>, an excellent book for professional devs that is on quite a few "must-read" lists.  If you're a dev and you haven't read this book, do so; although some of it is starting to look dated, and a chunk of it is pretty *nix-oriented (but not specific to those platforms), it's one of the classic texts that helps you look at your job in a different way.  I found it quite an enlightening read, and <a href="http://www.amazon.co.uk/Pragmatic-Programmer-Andrew-Hunt/dp/020161622X/">it's relatively cheap on Amazon</a>.
<!--break-->
