---
layout: post
title: ".NET Format Strings"
author: alastairs
nid: 20
created: 1219341474
---
.NET format strings rock.  These are roughly equivalent to the old-school C-style sprintf() functions, with their <code>%d</code>, etc., symbols.  There's some serious power to these strings, however; think PHP's date() function on acid, and for more than just dates.

None of this is likely to be new to all but the greenest of .NET developers (like me), but it's always worth reminding yourself of how great these things are.

[img_assist|nid=36|title=|desc=|link=node|align=none|width=400|height=407]
<!--break-->
You can pass format strings to the ToString() method of any object; .NET has some built-in logic that will help decipher certain format string.  For example, parity with PHP's date() function is achieved by passing a format string to the ToString() method on DateTime:

<blockcode language="csharp">
Console.WriteLine(DateTime.Now.ToString("dd/MM/yy h:mm"));
</blockcode>

outputs

<blockcode>20/08/08 6:40</blockcode>

So far, so PHP date().  The power of format strings comes in when used with the String.Format() method.  This is the bit that's similar to the sprintf() class of functions in C, etc.  For example, we can insert a representation of an object into a string:

<blockcode language="csharp">
Console.WriteLine(String.Format("Hello {0}", "world!"));
</blockcode>

outputs the classic

<blockcode>Hello world!</blockcode>

The beauty of that <code>{0}</code> place-holder is that <em>it directly indexes the remaining parameters passed to String.Format()</em>.  So we can do things like

<blockcode language="csharp">
Console.WriteLine(String.Format("This string was output at {3}:{4} on {0}/{1}/{2}",
    DateTime.Now.ToString("dd"), DateTime.Now.ToString("MM"), 
    DateTime.Now.ToString("yy"), DateTime.Now.ToString("hh"), 
    DateTime.Now.ToString("mm"));    
</blockcode>

It's a somewhat-contrived example (unless you're writing a logging system), but it illustrates the point.  It's hugely more programmer-friendly than having to do ten or so string concatenations.  In addition, String.Format() handily accepts an array as its second parameter.  If you pass in an array (and no further parameters), the place-holders then index the array!

The place-holders can include further formatting information, such as padding characters (e.g., leading zeros, ensuring currency figures are displayed to two decimal places, etc.).  The correct format here is as follows:
<blockcode lang="csharp">
Console.WriteLine(String.Format("{0:00000}", 50));      //Outputs "00050"
</blockcode>
The zero before the colon is the parameter indexer as before, and the bit after the colon is what does the actual formatting, padding the string with leading zeros.  Therefore, you can apply different formats to different parameters!

The flexibility of the latter part of the format strings is impressive too; you can use special characters to specify different built-in representations, such as "C" for currency (automatically inserts the currency symbol for the current locale and uses parentheses for negative numbers), "P" for percent (automatically inserts the % character), "X" specifies hex formatting&hellip;  And then there are <em>custom</em> format strings!

Kathy Kam at Microsoft published <a href="http://blogs.msdn.com/kathykam/archive/2006/03/29/564426.aspx" title=".NET Format String 101">an excellent summary of their capabilities</a> a couple of years ago that's become my go-to reference for these things.  There's also a <a href="http://blogs.msdn.com/kathykam/archive/2006/09/29/.NET-Format-String-102_3A00_-DateTime-Format-String.aspx" title=".NET Format String 102: DateTime Format String">follow-up post</a> describing further format strings specific to the DateTime type.  Check them out and see what other formatting wizardry you can accomplish!
