---
layout: post
title: Initialising a collection from another collection
author: alastairs
nid: 175
created: 1316106586
---
Here's a handy trick I discovered whilst fixing a bug.  You can initialise a collection from another collection and add new items to it as follows:

[gist:1219663]

Note that the collection initialiser on `AllFoo` runs *before* the constructor, so the `Foo` created with constructor parameter 4 will appear *first* in `AllFoo`, followed by everything in `BaseCollectionOfFoo` in the expected order.  
