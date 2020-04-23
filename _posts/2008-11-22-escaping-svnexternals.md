---
layout: post
title: Escaping svn:externals
author: alastairs
nid: 59
created: 1227379125
---
I've started using <a href="http://svnbook.red-bean.com/en/1.5/svn.advanced.externals.html">svn:externals</a> definitions to manage my libraries and tools like NAnt and NUnit.  In the words of the <a href="http://www.svnbook.com/">SVN Book</a>:
<blockquote cite="http://svnbook.red-bean.com/en/1.5/svn.advanced.externals.html">The convenience of the svn:externals  property is that once it is set on a versioned directory, everyone who checks out a working copy with that directory also gets the benefit of the externals definition. In other words, once one person has made the effort to define the nested working copy structure, no one else has to bother—Subversion will, after checking out the original working copy, automatically also check out the external working copies.  

<cite>Ben Collins-Sussman, Brian W. Fitzpatrick, C. Michael Pilato (2002). <em>Version Control with Subversion</em>. Sebastopol, CA: O'Reilly Media. 155.</cite></blockquote>

This works well for me: my external dependencies are versioned by Subversion, and are automatically downloaded/updated with my working copy of the current project once the externals' definition has been created.  It's pretty painless.  I did hit one bump today, however, when setting up my repository for my web frameworks' evaluation, and here I'll detail how I got over it.
<!--break-->
Possibly foolishly, I had set up the ASP.NET MVC repository structure under a directory called "ASP.NET MVC".  I did my usual thing of creating my externals' definition in a file, ran <code language="bash">svn propset svn:externals ./ --file FrameworksEvaluation.externals</code>, and BAM!  It exploded on me:
<blockcode>
svn: Error parsing svn:externals property on '.': 'ASP.NET MVC/trunk/tools/nanth
ttp://svn.alastairsmith.me.uk/tools/nant'
</blockcode>

Bugger.  I tried a couple of things, namely escaping the '.' and the space with a backslash, and quoting the local relative path.  No luck: I just kept getting the same error.  After a bit of Google searching resulting in my landing <a href="http://osdir.com/ml/version-control.subversion.tortoisesvn.devel/2005-08/msg00607.html" title="Re: can't set svn:externals property to reference a directory with a space: msg#00607 version-control.subversion.tortoisesvn.devel">here</a>, I remembered something that the SVN book mentioned about externals' definitions: SVN doesn't use paths as such; instead it uses URLs.  <strong style="text-decoration:line-through;">URL-encoding the space as %20 fixed the solution.</strong>  It seems that <a href="http://svn.haxx.se/dev/archive-2008-10/0213.shtml">there's a fix for this "bug" in SVN 1.5</a>, so watch out if you're upgrading.

<h2>Update</h2>
Whilst it is true that URL-encoding spaces as %20 fixes the issue for the <code>propset</code>, when I ran <code>svn up</code> to download the external dependencies, I ended up with a new directory called "ASP.NET%20MVC".  Not what I wanted.  It appears this is <a href="http://subversion.tigris.org/issues/show_bug.cgi?id=2461" title="Subversion Issue 2461:svn:externals doesn't support spaces in local path">a known bug</a>, and further looks to be another instance of the bug I reported as having been fixed.  It looks as though I'm going to be upgrading to SVN 1.5 this weekend...
