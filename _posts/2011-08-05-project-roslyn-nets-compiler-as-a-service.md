---
layout: post
title: 'Project Roslyn: .NET''s Compiler as a Service'
author: alastairs
nid: 167
created: 1312585126
---
I spent some of this evening watching the video from Microsoft Research on their Project Roslyn, the codename for the Compiler-as-a-Service functionality they're developing for .NET vFuture.  
<!--break-->
The most interesting parts of the talk for me were:

1. The C# and VB compilers are being completely re-written.  The compilers have been written, for the last 10+ years in C++, and have been black boxes that take in source code and spit out IL.  The Roslyn compilers are being written in *managed code*, in part to enable greater componentisation so that, for example, you can plug directly into the part of the compilation pipeline that most interests you.  
2. Looking at the APIs Roslyn exposes, it seems like products like ReSharper will become much more easily implemented.  Will this introduce more competition into the refactoring tools market?  Maybe.  The Syntax Tree API (slides 19-23) looks very readable.
3. Anders Hejlsberg is lead architect of Roslyn.
4. A consideration is to release an open-source version of Roslyn to enable experimentation with your own new language features.  (There will be no support for extending or modifying the parser through the compiler APIs).
5. The kind of refactorings Roslyn will enable go way beyond the existing Rename Method and Extract Interface. Roslyn can enable refactorings that modify your code to, e.g., increase program security, or increase performance. These are things that would otherwise have to be designed into the program from the beginning.  

There's also some interesting stuff on how people use refactoring tools.  

You can view the full video embedded below, or [with slides on Microsoft Research's site.](http://research.microsoft.com/apps/video/default.aspx?id=152281)  [Silverlight](http://www.microsoft.com/getsilverlight/get-started/install/default.aspx?reason=unsupportedbrowser#) is required to view either.

<object data="data:application/x-silverlight-2," type="application/x-silverlight-2" width="320" height="246"><param name="source" value="http://research.microsoft.com/apps/video/ClientBin/EmbeddedPlayer.xap"/><param name="enableHtmlAccess" value="true" /><param name="initParams" value="id=152281,start=0,end=4551" /><param name="background" value="white" /><param name="minRuntimeVersion" value="3.0.40818.0" /><param name="autoUpgrade" value="true" /><a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=3.0.40818.0" style="text-decoration:none"><img src="http://go.microsoft.com/fwlink/?LinkId=108181" alt="Get Microsoft Silverlight" style="border-style:none"/></a></object>
