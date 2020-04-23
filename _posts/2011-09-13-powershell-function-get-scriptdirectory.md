---
layout: post
title: PowerShell function Get-ScriptDirectory
author: alastairs
nid: 174
created: 1315951975
---
Very often when I'm writing a script in PowerShell, I will need to obtain the directory in which that same script resides.  This is sadly not completely trivial in PowerShell, but the following function achieves the desired result:

[gist:1215274]

Hopefully, having created a gist for this and blogged about it, I won't have to keep resorting to Google in future to remind me how to do this.  This particular version was posted to [the PowerShell Code Repository](http://poshcode.org/2887) by Andy Arismendi.  
