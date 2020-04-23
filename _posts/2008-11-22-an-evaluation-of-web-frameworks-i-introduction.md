---
layout: post
title: 'An Evaluation of Web Frameworks I: Introduction'
author: alastairs
nid: 58
created: 1227314320
excerpt: !ruby/string:Sequel::SQL::Blob "Following on from a recent comment discussion,
  I'm taking on a small project to evaluate a number of the major web development
  frameworks currently available.  I've settled on a very simple blogging system as
  my sample project, with a common MySQL backend.  In this first post of the series,
  I set out the terms of reference for the evaluation, including the (very basic)
  requirements for the sample application.\r\n"
---

Following on from a recent comment discussion, I'm taking on a small project to evaluate a number of the major web development frameworks currently available.  I've settled on a very simple blogging system as my sample project, with a common MySQL backend.

<h3>Outline</h3>

I intend to evaluate one framework per language, as follows:
<ul>
  <li><strong>PHP:</strong> <a href="http://www.cakephp.org/">CakePHP</a></li>
  <li><strong>ASP.NET:</strong> <a href="http://www.asp.net/mvc/">ASP.NET MVC</a>.  <em>[Note: I may throw in some <a href="http://msdn.microsoft.com/en-us/library/ms973868.aspx?ppud=4">WebForms</a> and <a href="http://quickstarts.asp.net/3-5-extensions/dyndata/ASPNETDynamicDataOverview.aspx">Dynamic Data</a> too, depending on progress and whether it's suitable or not.  <a href="http://www.hanselman.com/">Scott Hanselman</a> did <a href="http://www.hanselman.com/blog/PlugInHybridsASPNETWebFormsAndASPMVCAndASPNETDynamicDataSideBySide.aspx">a good post that combined the three in a "hybrid" application</a>.]</em></li>
  <li><strong>Python:</strong> <a href="http://www.djangoproject.com/">Django</a></li>
</ul>

Depending on how I progress, I will also investigate the following secondary frameworks, in order of precedence:
<ol>
  <li><strong>PHP:</strong> <a href="http://framework.zend.com/">Zend Framework</a></li>
  <li><strong>Ruby:</strong> <a href="http://www.rubyonrails.org/">Ruby on Rails</a></li>
</ol>

<h3>Requirements</h3>

When I say the blog application will be simple, I <em>really</em> mean it.  Each implementation is a proof-of-concept experiment to attempt to get a handle on the frameworks, so it won't support formatting, picture uploading, or anything else even vaguely fancy.  It will support two different roles: reader (anonymous) and full admin (authenticated).  Posts will contain a title, body, publication date, and author's name/handle.  Comments will be anonymous with no verification, not least because there won't be any user management.  

<h3>Progress Reporting</h3>

I'll publish my evaluation on one or more <a href="http://trac.edgewall.org/">Trac</a> sites; my Trac index is available at <a href="http://trac.alastairsmith.me.uk/">.  I haven't decided whether or not to go to trouble of creating separate repositories and sites for each implementation yet.

Each framework will be the subject of one or more blog posts, describing current progress for that implementation, frustrations along the way, and neat features of the framework that have eased the implementation.  <strong>Update:</strong> You can find the whole series <a href="http://www.alastairsmith.me.uk/category/coding/web-frameworks-evaluation">here</a>, and there's a link to an RSS feed for the series on that page too.  

Please leave me a comment if you'd like to see something else feature in this experiment.  <strong>The only thing I won't add to is the list of frameworks</strong>; I think this is big enough already! :-)

I hope to get started this weekend.  Wish me luck!
