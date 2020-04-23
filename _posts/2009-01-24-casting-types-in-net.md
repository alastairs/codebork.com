---
layout: post
title: Casting types in .NET
author: alastairs
nid: 67
created: 1232755561
---
In Java, there's only one way to explicitly cast a variable from one type to another, and that's using the bracket syntax.  In .NET (well, C# anyway), there are a couple: the Java-esque bracket syntax and the <code language="csharp">as</code> keyword.  Whilst I have used both frequently in the past, a situation occurred a couple of days ago where I realised I needed to clarify what <code language="csharp">as</code> did under the hood.
<!--break-->
I was working through the Java examples of <a href="http://www.alastairsmith.me.uk/coding/2008/09/13/test-driven-development.html" title="Test-Driven Development"><em>Test-Driven Development by Example</em></a> in C# using the MSTest framework included with Visual Studio 2008 when I came across some funny polymorphism and casting that seemed valid in the example but wouldn't compile in C#.  It later transpired that I'd missed a step in the super-class, but as I tried the two different methods of casting, I realised they were different and I wasn't sure how.  

In C#, the explicit cast bracket syntax is identical to that in Java:
<div style="float: left; width: 50%;">
<strong>Java</strong>
<blockcode language="java">
char x = 'x';
int y = (int) x; 
</blockcode>
</div>
<div>
<strong>C#</strong>
<blockcode language="csharp">
char x = 'x';
int y = (int) x;
</blockcode>
</div>

Under the hood, this also works the same way as it does in Java: it attempts to cast the one type to the other, and throws an exception if the types are not compatible.  

Both languages also support implicit casting, which allows you to do things like:
<blockcode language="csharp">
int x = 10;
long y = x;
</blockcode>

C# also provides an <code language="csharp">as</code> keyword for reference types; it won't work on value types like int, double, etc.  This is a second form of explicit casting, and it is used as follows:
<blockcode language="csharp">
Superclass superclass = new Superclass();
Subclass obj = superclass as Subclass;
</blockcode>

This is a nifty trick, providing a form of checked casting.  What happens when you use the <code language="csharp">as</code> keyword is that the type is cast as before, but if the cast to <code language="csharp">Subclass</code> fails, <code language="csharp">obj</code> is set to <code language="csharp">null</code>.  Under the hood, this is what happens:
<blockcode language="csharp">
expression is type ? (type)expression : (type)null
</blockcode>
(where <code language="csharp">is</code> is C#'s equivalent of Java's <code language="java">instanceof</code>).  Note that in this example <code language="csharp">expression</code> is only evaluated one for the entire statement.

This is rather basic C# stuff, but sometimes you get a situation where it helps to remind yourself what's going on behind the high-level constructs.
