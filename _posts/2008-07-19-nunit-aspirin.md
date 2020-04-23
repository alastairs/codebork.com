---
layout: post
title: NUnit Aspirin
author: alastairs
nid: 25
created: 1216486682
---
I finally resolved my NUnit headaches.  Turns out the aspirin I needed to was to <abbr title="Read the Fucking Manual">RTFM</abbr> and continue to <a href="http://blog.jpboodhoo.com/AutomatingYourBuildsWithNAntPart5.aspx" title="Automating your builds with NAnt &mdash; Part 5">the next step of Jean-Paul Boodhoo's guide to NAnt</a>.  

[img_assist|nid=24|title=|desc=|link=url|url=http://en.wikipedia.org/wiki/Aspirin|align=center|width=500|height=400]

Had I done this before, I would have realised that in order to get NUnit working in the manner I wished, I needed to copy the NUnit DLLs either to the <abbr title="Global Assembly Cache">GAC</abbr> or to the build staging area so that they resided in the same directory as my Unit Tests' DLL.  The latter is the preferred method.  I would also have learned that I needed to copy any other dependent assemblies, such as <a href="http://logging.apache.org/log4net/index.html" title="Apache log4net">log4net</a> and <a href="http://www.nmock.org/" title="NMock">NMock</a> as part of the build process.
<!--break-->
So why is it necessary to copy these DLLs to the same directory?  Because whilst the .NET dependency resolution is fairly bright (the GAC is pretty cool), it's not all <em>that</em> bright, and most developers don't both extending its behaviour.  I guess it's not really worth the bother.  

What would be more useful, however, is for the compile-time reference information to be shoved into the .NET assembly, so that it can try that location before any others (it could additionally resolve the relative path provided at compile to an absolute path and so try both options).  I guess, however, that most build environments don't reflect the final production environment post-install, so maybe that's why this functionality isn't there.  

As I mentioned before, this option is preferred over installing NUnit to the GAC.  This is because this would tie me to the installed version of NUnit.  If I upgraded my tools depot to NUnit 2.5, and built my unit tests with NUnit 2.5, I'd have to go messing around with <a href="http://www.alastairsmith.me.uk/coding/2008/07/19/nunit-headaches.html" title="NUnit Headaches">that assembly redirection/rebinding I mentioned in my previous post</a>.  Either that, or upgrade NUnit in the GAC too.  This way, I have more independence in choosing the version of NUnit I use and flexibility in using it, which is the exact same reason I dropped the use of the <nunit2> task in my build files.  

Maybe now I can get on with unit testing my Message Manager!  :-)
