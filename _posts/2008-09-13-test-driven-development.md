---
layout: post
title: Test-Driven Development
author: alastairs
nid: 44
created: 1221261048
---
I've recently started reading Kent Beck's excellent book <a href="http://www.amazon.co.uk/Test-Driven-Development-Addison-Wesley-signature/dp/0321146530/ref=sr_1_1?ie=UTF8&s=books&qid=1221258043&sr=1-1" title="Test-Driven Development by Example on Amazon.co.uk"><i>Test-Driven Development by Example</i></a> at work as part of my self-development goals for this quarter.  Test-Driven Development (TDD) is something that I'd heard about, and knew the basic principle of (write the unit tests first and write the code to pass them), but had never tried or bothered to read up on.  There's an emphasis in our team at work on moving to a more agile way of working so that we can better respond to the different demands of the two products the Web Interface supports: Citrix XenApp and Citrix XenDesktop.  It's one of those changes that is more easily talked about than accomplished, and for a while at least it will be mostly talk.  However, TDD seems to fit in quite nicely as a halfway house between our current development practices and a fully agile environment: we (obviously) currently write unit tests, although our test coverage is possibly lower than we'd like; TDD isn't explicitly agile, being an implementation method or coding technique rather than a project methodology.  In short, it would be a small step to move from where we are now to now + TDD, and then (hopefully) an easier step from now + TDD to "agile".  

But enough about Citrix and back to the book and TDD.  The book is written in four sections: an example application developed using TDD; an introduction to the <a href="http://en.wikipedia.org/wiki/XUnit" title="Wikipedia article on the xUnit frameworks">xUnit frameworks</a> (specifically <a href="http://www.junit.org/" title="JUnit homepage">JUnit</a>); an introduction to <a href="http://www.alastairsmith.me.uk/category/coding/design-patterns" title="My Design Patterns' series">design patterns</a>; and an introduction to re-factoring.  The last two may initially seem incongruous, but re-factoring is a core part of the TDD mindset; design patterns provide "template" implementations for common problems which speed up your coding and are proven quantities (and thus are easier to test).  The example application (multi-currency money support) is actually a good example, being simple enough to understand in a single a concept, and yet complex enough to make an interesting exercise.    

Beck walks through the example in a series of 10 or so chapters, adding roughly one new test per chapter and implementing the code that will be exercised by the test.  Each chapter follows the TDD cycle of:
<ol>
<li>Add a test</li>
<li>Run all the tests to check the new one fails</li>
<li>Write some code to fix/pass the test</li>
<li>Run all the tests to make sure they succeed and nothing's been broken by your change</li>
<li>Re-factor to clean up, remove duplication, etc.</li>
</ol>

This is repeated until the component is finished, and is begun again each time new functionality is added to the component.  

One of the (many) great things about TDD is that because you write the test first, you automatically produce the simplest, most useful interface to your classes.  For example:
<blockcode lang="java">
public void testFivePlusFiveEqualsTen() {
    Dollar five = new Dollar(5);
    Dollar result = five.plus(new Dollar(5);
    assertEquals(new Dollar(10), result);
}
</blockcode>

That's right folks, TDD makes you write cleaner code!

The tests continue in a similar vein throughout this section, with the code being implemented in parallel.  With that in mind <strong>it really is best to implement the code samples as you read.</strong>  I didn't do this, and regretted it by the end of the section, as some of the tests and changes had got quite complex.  

Another good thing about TDD is that you instantaneously get near-100% code coverage.  As is customary to mention at this point, coverage is no indicator of product or code quality, but it is a useful statistic for identifying "holes" of code that isn't tested at all.  

The book is well-written: a good sense of humour pervades throughout the text, without getting in the way.  Unlike <i>Don't Make Me Think!</i>, it is not littered with footnotes.  

I knew before reading <i>Test-Driven Development by Example</i> that TDD was good, and I ever so vaguely knew why (it gets you writing unit tests!), but I hadn't grasped <em>just how good</em> it actually is.  I've quickly become a bit of a TDD evangelist, and I most certainly will be looking to make use of it in my next task at work (it's too late for my current task to get any real benefit from it).  It's also got me thinking about unit testing our JavaScript code (<a href="http://www.jsunit.net/" title="JsUnit homepage">JsUnit</a> looks like a good start), as we make heavy use of this and it currently has low unit test coverage.  

If you're not already using TDD, I strongly recommend looking into it for your own projects &mdash; be they private home-brew projects or tasks at work &mdash; and buy a copy of this book as an introduction.  
