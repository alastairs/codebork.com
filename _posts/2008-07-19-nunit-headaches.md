---
layout: post
title: NUnit Headaches
author: alastairs
nid: 22
created: 1216424333
---
So my promised updates on other things haven't quite come to fruition...  This week's been kinda busy.  

But this evening I sat down with NAnt and NUnit to try and get my Unit Tests working under NUnit and running from the automated NAnt build, and, six hours later, I'm still here.

[img_assist|nid=21|title=|desc=|link=none|align=center|width=427|height=640]
<!--break-->
The first headache was trying to get the <nunit2> task in NAnt to work with my tests.  NAnt ships with NUnit 2.2.8, whereas I've been using the <em>much</em> more up-to-date 2.4.7 version.  Very early, I ran into the dreaded "could not load file or assembly" error, and looking again at the docs for the <a href="http://nant.sourceforge.net/release/0.86-beta1/help/tasks/nunit2.html" title="&lt;nunit2&gt; task">&lt;nunit2&gt; NAnt task</a> I discovered I needed to redirect the assembly bindings via a test.config file, but it took me a <strong>very</strong> long time to work out that I'd got my oldVersion and newVersion the wrong way round :-(
<blockcode language="xml">
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
    <runtime>
        <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
            <dependentAssembly>
                <assemblyIdentity name="nunit.framework" publicKeyToken="96d09a1eb7f44a77" culture="Neutral" /> 
                <bindingRedirect oldVersion="2.2.8.0" newVersion="2.4.7.0" /> 
            </dependentAssembly>
        </assemblyBinding>
    </runtime>
</configuration>
</blockcode>

Line 7 should actually read:
<blockcode language="xml">
                <bindingRedirect oldVersion="2.4.7.0" newVersion="2.2.8.0" /> 
</blockcode>
so that my 2.4.7-bound tests can be run with the 2.2.8 binaries provided with NAnt.  Something in <a href="http://www.hanselman.com/blog/CommentView.aspx?guid=a9e7d7d7-027c-44de-b873-4d6c6e3255b2" title="Calling NUnit from NAnt Pragmatically">Scott Hanselman's post on the subject</a> helped me grasp this fact in a flash of inspiration.  

However, Scott recommends invoking nunit-console.exe with the &lt;exec&gt; task &mdash; a more generic call-an-external-program sort of task.  For example,
<blockcode language="xml">
<exec program="path\to\nunit-console.exe">					
    <arg value="My.Tests.dll" />
    <arg value="/xml=results\My.Tests.xml" />
    <arg value="/nologo" />
</exec>
</blockcode>

Unfortunately, I'm back to square one with this method.  Running nunit-console.exe directly from the command line gives me the exact same "could not load file or assembly" error that I was suffering earlier, and, unsurprisingly, I get the same results through my NAnt build:
<blockcode>
NUnit version 2.4.7
Copyright (C) 2002-2007 Charlie Poole.
Copyright (C) 2002-2004 James W. Newkirk, Michael C. Two, Alexei A. Vorontsov.
Copyright (C) 2000-2002 Philip Craig.
All Rights Reserved.

Runtime Environment -
   OS Version: Microsoft Windows NT 5.1.2600 Service Pack 2
  CLR Version: 2.0.50727.1433 ( Net 2.0.50727.1433 )

Could not load file or assembly 'nunit.framework, Version=2.4.7.0, Culture=neutral, PublicKeyToken=96d09a1eb7f44a77' or
one of its dependencies. The system cannot find the file specified.
</blockcode>

Note there that <strong>NUnit version 2.4.7 is unable to load the nunit.framework assembly at version 2.4.7</strong>.  I've trashed my test.config file, so I'm not doing any assembly re-binding any more, and NUnit is housed within it's own directory in my working copy.  Goodness only knows what's going on here &mdash; maybe I'll find out tomorrow...
