---
layout: post
title: 'PowerShell one-liner: extract all zip files'
author: alastairs
nid: 153
created: 1296849600
excerpt: !ruby/string:Sequel::SQL::Blob "I'm a big fan of <a href=\"http://www.tekpub.com/\"
  title=\"TekPub - High-quality screencasts for programmers.\">TekPub</a> and its
  thorough video tutorials on a wide range of development topics from frameworks like
  ASP.NET MVC and Ruby on Rails to building apps for the various mobile devices, to
  their free series such as key development concepts.  \r\n\r"
---
I'm a big fan of <a href="http://www.tekpub.com/" title="TekPub - High-quality screencasts for programmers.">TekPub</a> and its thorough video tutorials on a wide range of development topics from frameworks like ASP.NET MVC and Ruby on Rails to building apps for the various mobile devices, to their free series such as key development concepts.  

The videos are streamed from the TekPub website, or, if you buy an individual series or an annual subscription, you can download the videos to keep.  The downloads are zipped-up video files (.wmv or .mp4), and so each file needs to be extracted before it can be watched.  When I download the zip files, I like organise them into a folder per series, under a top-level TekPub folder, something like the following:
<pre>
  + TekPub
  |  + ASP.NET MVC 2
  |  |  Episode 1.zip
  |  |  Episode 2.zip
  |  + Ruby on Rails 3
  |  |  Episode 1.zip
  |  |  Episode 2.zip
  |  |  Episode 3.zip

  ...etc.
</pre>

Expanding and then deleting each zip file is a dull manual process, so like any good developer, I chose to automate it.  Here's a PowerShell one-liner to expand and then delete all the archives found in this sort of shallow directory structure.  It wouldn't be too difficult to convert it to a fully-recursive process, so I leave that as an exercise for the reader :-) 

<script src="https://gist.github.com/748258.js?file=Expand-AllArchives"></script>
