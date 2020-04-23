---
layout: post
title: Implicit Interface Implementation in .NET
author: alastairs
nid: 173
created: 1314043654
---
I've just been reading Brad Wilson's latest blog post, [Interface Attributes != Class Attributes](http://bradwilson.typepad.com/blog/2011/08/interface-attributes-class-attributes.html), and hit upon this interesting nugget regarding the implicit implementation of interfaces in .NET:

> Implicit implementation (as seen above) is when a class implements the method/property in question as
> a public method or property on the class. It's important to note that this method/property is NOT the
> same thing as the interface method/property; it merely has the same signature, and thus can be used to
> implicitly create the implementation of the interface. In reflection terms, the two are distinct and
> different.

Hum. I did not know that.
<!--break-->
