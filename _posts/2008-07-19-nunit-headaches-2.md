---
layout: post
title: NUnit Headaches 2
author: alastairs
nid: 23
created: 1216467442
---
Following up on last night's <a href="http://www.alastairsmith.me.uk/coding/2008/07/19/nunit-headaches.html" title="NUnit Headaches">NUnit Headaches</a>, I managed to solve the problem in a relatively short amount of time.  

Closer inspection of the error message received revealed that the nunit.framework DLL could not be located.  Adding nunit.framework.dll and nunit.core.dll to the <abbr title="Global Assembly Cache">GAC</abbr> fixed this.  My impression was that the installutil .NET tool did this for me; turns out that's not the case, and I needed the gacutil tool in the Windows SDK instead.

Now I just have to work out how to resolve the same error with the DLL under test without adding <em>that</em> to the GAC as well.  Maybe then I can fix NUnit in the same way and uninstall NUnit from the GAC.
<!--break-->
