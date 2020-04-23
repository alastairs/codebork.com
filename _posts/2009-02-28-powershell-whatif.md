---
layout: post
title: PowerShell -whatif
author: alastairs
nid: 75
created: 1235782609
---
PowerShell is Microsoft's new command line shell for Windows.  Version 1 was released in 2006, and version 2 has been in <abbr title="Community Technology Preview">CTP</abbr> for about a year now; it will finally RTM with Windows 7.  It's a truly fantastic shell, and if you haven't looked into it already, I would urge you to do so.  There's a wealth of information out there, not least on <a href="http://blogs.msdn.com/powershell/">the PowerShell blog</a>, that will get you started very quickly.  

I'm such a fan of PowerShell that I'm quite surprised I haven't posted about it here in any detail before.  One of the key advantages is that it is a first-class .NET language, giving you access to the entire .NET framework from the command-line; this arises from the basic data item being an object (rather than plain text as it is in UNIX shells).  I hope to post an introduction/tutorial to PowerShell sometime in the near future.  

The subject of this post, however, is a specific feature of PowerShell, the <code>-whatif</code> switch.  I assume familiarity with basic PowerShell features, and the PowerShell syntax.
<!--break-->
Recently at work, I was writing some PowerShell scripts to automate some XML manipulation.  Unfortunately, I got the script a bit wrong, and so the XML manipulation didn't work as expected.  This could have been avoided had I not forgotten about <code>-whatif</code>.  Additionally, I was running the script in a sandbox location, which meant duplication of files and directory structure; this too could have been avoided if by using the -whatif switch.  

<a href="http://computerperformance.co.uk/ezine/ezine157.htm" title="Ezine 157 - PowerShell's WhatIf">More of a magic shield than a magic bullet</a>, <strong><code>-whatif</code> does a dry run of your script</strong>.  Supplying <code>-whatif</code> to your command line runs the script <em>exactly as it would be run</em>, but without making any actual modifications.  As such, it is only valid on cmdlets that make modifications; supplying it to a get-* cmdlet will throw an error.  

What follows is a slightly contrived example, but bear with me :-)  Say my log directory (e.g., <code>C:\logs</code>) was getting a bit full and hard to manage, I might want to delete all old log files, where "old" means more than one week old.  The following code looks good, but there's a not-so-subtle error in it.  

<blockcode>
Get-ChildItem -Filter *.log C:\logs |? { 
    $_.LastWriteTime -gt (Get-Date).AddDays(-7) 
} | Remove-Item
</blockcode>

Running this one-liner (formatted to reduce scrolling) as-is will cause a huge screw-up: I've got the logic wrong for the date comparison, and suddenly I've deleted all my most recent log files.  

<blockcode>
Get-ChildItem -Filter *.log C:\logs |? { 
    $_.LastWriteTime -gt (Get-Date).AddDays(-7) 
} | Remove-Item -whatif
</blockcode>

Adding that one flag does a dry-run, and gives me the following verbose output:

<blockcode>
What if: Performing operation "Remove File" on Target "C:\logs\270209.log".
</blockcode>

"Wait a minute", I think, "that file is dated with today's date.  I must have got the logic wrong!"  And so my ass and my log files are saved.  Flicking the comparison from a <code>-gt</code> to a <code>-lt</code> and leaving the <code>-whatif</code> switch enabled confirms my suspicions, and I now have the confidence to let PowerShell remove those old log files for me.  

This is a really important and useful switch, and if you write PowerShell artefacts (scripts, cmdlets, etc.) that you share with others, <strong>you really should support this switch</strong>.  <a href="http://blogs.msdn.com/powershell/archive/2007/02/25/supporting-whatif-confirm-verbose-in-scripts.aspx" title="Windows PowerShell Blog : Supporting -Whatif, -Confirm, -Verbose &mdash; In SCRIPTS!">And don't forget to implement the other standard switches</a> while you're at it.  

Now all I need to do is train myself to test out my PowerShell artefacts with this switch before I run them for real.
