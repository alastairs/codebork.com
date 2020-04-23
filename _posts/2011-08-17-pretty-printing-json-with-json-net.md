---
layout: post
title: Pretty-printing JSON with Json.NET
author: alastairs
nid: 171
created: 1313611296
---
I was struggling to find a way to pretty-print a JSON string in .NET.  I already have the excellent [Json.NET](http://nuget.org/List/Packages/Newtonsoft.Json) package available and after a bit of hunting, I came up with this:

[gist:1152445]

It wasn't obvious how to do this, for some reason - I spent a while investigating the `JsonReader` and `JsonWriter` classes to no avail.  

Hope this helps you too!
