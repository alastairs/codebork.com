---
layout: post
title: Stack Overflow Dev Days - London
author: alastairs
nid: 118
created: 1257706596
---
On Wednesday 28 October 2009, Joel Spolsky and Jeff Atwood brought their Stack Overflow sideshow to London's Kensington Town Hall, and I was lucky enough to be one of the ~1000 people attending.
<!--break-->
<h3>Registration and Opening Keynote</h3>

The day opened early, with registration starting soon after 8am, and we were soon gulping copious amounts of coffee, breakfast, and collecting bags of swag (free FogBugz book, Super User and Server Fault stickers, etc., etc., etc.) from the various exhibitors before Joel's opening keynote.  After an excellent and incredibly geeky send-up of <a href="http://en.wikipedia.org/wiki/Scrubs_%28TV_series%29" title="Scrubs on Wikipedia">Scrubs</a> set in the Fog Creek offices, Joel spoke on simplicity vs power.  Ribbing <a href="http://37signals.com" title="37Signals' website">37Signals</a>, one of the darlings of Web 2.0, more than a little for their "oversimplified" user interfaces ("Hey, anyone can create an HTML page and slap a &lt;textarea /&gt; on it!"), he demonstrated how many products start out as simplified versions of another product, and soon expand to fit user's requirements.  Of particular note was that old customer line, "if you include feature x, we'll sign now" (ok, so I paraphrased a bit, but you get the picture :-) that seems to drive product complexity like no other factor on Earth.  As features are added, so the UI becomes more cluttered, it's harder to find feature y or complete task a, and smart developers start thinking, "I could knock up a simplified version of this overnight and make my fortune!".  All this has happened before and all this will happen again.  

The crux of Joel's keynote was that there's nothing wrong with losing a bit of simplicity to add extra power to your product.  Coming from an ex-Program Manager of Excel this is not unexpected, but please: in all things, moderation.  The power in Microsoft's Office suite necessitated a drastic overhaul of their UI paradigms for Office 2007 because users were stuck in nested menu hell, concentrating more on how to accomplish their tasks than they were on what they wanted to accomplish!

<h3>Python</h3>

Michael Sparks from the BBC's R&D arm spoke about Python, using <a href="http://norvig.com/spell-correct.html">Peter Norvig's spelling corrector</a> as the basis for his talk.  This was quite an impressive talk in many respects, simultaneously illustrating the power of Python (the code was ~21 lines of code, all function definitions) and walking through Norvig's surprisingly simple implementation of a complex software component.  The corrector is used on Google's search pages, and uses Bayes' theorem to guess the word that you meant based on a corpus of words that it might have been, and a couple of rules indicating how you might have mis-spelled the word.  These rules are things like transposed letters, a missing letter, an added letter, etc.  Google, of course, uses as its corpus of knowledge <a href="http://www.youtube.com/watch?v=iDbyYGrswtg" title="Moss introduces Jen to a new concept in business technology: The Internet.">The Internet</a>.

<h3>Android</h3>

Reto Meier of Google spoke eloquently on the Android platform.  This was a very interesting talk, and illustrates how Google gets the idea of helping developers in a way that Apple just doesn't.  Android is completely Java-based; Apple require developers to code in Objective-C (more on this later).  The Android framework looks like it might be the simplest framework for mobile development, and the devices are proving to be hot contenders to the iPhone (see The Register's reviews of the <a href="http://www.reghardware.co.uk/2009/08/10/review_phone_htc_hero/" title="HTC Hero review on Reg Hardware">HTC Hero</a> and the <a href="http://www.reghardware.co.uk/2009/05/06/review_smartphone_htc_magic/" title="HTC Magic review on Reg Hardware">HTC Magic</a>, for example). 

The Android SDK includes APIs to call into a number of services (including location, search and multimedia) and sensor measurements.  The sensors include accelerometers, orientation sensors, a compass, and even a thermometer.  Like most mobile platforms these days, Android also supports home-screen widgets. 

Unlike the iPhone, Android supports background processes, allowing for multi-tasking.  Therefore, you can listen to music whilst reading your emails, something the iPhone is infamously unable to even with its own iTunes app.  Partially as a result of the multi-tasking support, it also supports inter-process communications, allowing applications to share data.  For example, you can create an "Intent" in a contacts application that exposes a Geo URL (maybe retrieved from the contact's address), and open it in Google Maps.  To desktop users, this is nothing new: ShellExecute and its ilk have been around since the dawn of time almost. 

New features for Android version 2.0 include Bluetooth support (this was removed from the 1.0 release), aggregation of contact information from different sources, a camera API (effects, flash mode, focus mode, etc., etc.).

The Android development environment is Eclipse, with some specific plug-ins.  A nice feature of this is the ability to create a completely custom Android softphone in the emulator, defining the SDK version and hardware parameters from whether a camera is installed right down to the capacity of the SD card (and whether or not there is even an SD card present).  The virtual devices are significantly slower than hardware devices, but Meier said that most apps run tolerably on the virtual devices. 

Interestingly, the Android's localisation support looks very good: the developer provides separate resources files for each locale, they're compiled into the app, and the appropriate file is loaded based on the phones locale settings.  This approach also works for supporting different hardware configurations.

Sadly, the iPhone continues to reign supreme, even amongst the developers; when asked, fewer than 1% of the attendees owned an Android phone.  

<h3>jQuery</h3>

This was mostly an introduction to jQuery - what it is and how to use it - but it also covered the slightly more advanced topic of jQuery plugin development.  Presented by Remy Sharp of the Full Frontal JavaScript Conference.

If you've done any web development in the last year or two, you've probably come across jQuery; if you haven't, it's a framework for JavaScript that takes the pain out of JavaScript development by abstracting away the various browser quirks and differences, and provides a nice API for manipulating the various bits of HTML on your page.  This API is based around the CSS selectors, so it allows developers to reuse existing knowledge.  For example, the following example applies row striping to all tables on the page:

<blockcode language="javascript">$('table tr:nth-child(odd)').addClass('odd');</blockcode>

There's a useful sandbox site available at www.visualjquery.com for trying out your jQuery code. 

The basic execution model jQuery uses is "Find or create something, then do something".  To facilitate this model, the jQuery object supports chaining; i.e., each method on the jQuery object modifies the jQuery object and returns it.  Iteration is implicit within the API, such as via the each() function.  It's also important to note that the selectors fail silently, and that they are evaluated from right to left.  For example

<blockcode language="javascript">$('a[title][hash*="foo"]');</blockcode>

searches first for all elements with the hash attribute containing a value like "foo" (the values "foobar" "myfoo" and "myfoobar" will all be matched), then restricts that set to the elements that also have the title attribute applied, and finally restricts that set to just anchor elements.

Furthermore, you can contextualise the query by passing in a second selector; this can dramatically improve performance.  For example

<blockcode language="javascript">$('.header', '#main');</blockcode>

looks within in the tree rooted at the element with id "main" for elements with the header class applied. 

Functions that deal with some kind of value are generally accessors, i.e. they can set and retrieve the value.  Finally, there are two types of search: find() implements a Depth-First Search (vertical) on the HTML tree, whilst filter() implements a Breadth-First Search (horizontal). 

Check out http://codylindley.com/jqueryselectors to see these in action.  

<h3>FogBugz 7</h3>

Joel gave us a demo of <a href="http://www.fogcreek.com/FogBUGZ/" title="FogBugz">FogBugz 7</a>, and the related sales pitch.  It's a pretty neat issue tracking system, and a big improvement over FogBugz 6 from what I gather.  However, I found the user management features are sorely lacking to the point that managing more than ten, maybe twenty, users must be incredibly frustrating, and there are few permissions to lock down the actions a user can take on a bug report at any stage of its lifecycle.

<h3>Stack Overflow Careers</h3>

Jeff Atwood introduced this new job hunting service from the Stack Overflow team, currently in beta.  The twist is that employers come to Stack Overflow Careers to find new employees, rather than posting jobs and prospective employees applying for them.  

There's an introductory offer currently running for developers where you get 3 years' membership for $29 (<strong>expires 9 November 2009, tomorrow!</strong>).  Pricing for employers is still being decided, but I think this is where Joel and Jeff intend to make the serious money so it won't be cheap.  This seems also to be aimed at avoiding recruitment agencies and lower-standard employers:

<blockquote>We believe that <span style="color: red;">every professional programmer should have a job they love</span>, and current sites like Monster, DICE, craigslist, and so forth do a woefully inadequate job of matching professional programmers with the type of employers who understand the true value of programmers who <a href="http://www.joelonsoftware.com/articles/HighNotes.html" title="Hitting the High Notes from Joel on Software">hit the high notes</a>.</blockquote>
 
That's a fairly half-baked explanation of a pretty cool concept, so if you want to find out a bit more, check out <a href="http://blog.stackoverflow.com/2009/10/introducing-stack-overflow-careers/" title="Introducing Stack Overflow Careers">the announcement from which the above paragraph is taken.  Joel has also done <a href="http://www.joelonsoftware.com/items/2009/11/05.html" title="Upgrade your Career">an announcement</a> of the service, in his own inimitable style :-) 

<h3>Qt</h3>

The only key takeaway from this presentation was "avoid programming for Symbian and Qt at all costs".  Architecturally, it looks like quite a good SDK (and it runs on desktops as well as Symbian phones), but the developer support and build quality of the SDK are both very poor, to the point where the Nokia guy, Pekka Kosonen, couldn't get his demos working.  Luckily Pekka was quite candid about the problems facing Nokia and what his talk lacked in quality he more than made up for in humour!  There are plans under foot to improve the situation, but we're talking years until they've caught up with Apple. 

Amusingly, the Qt freebie (a bag) was about as useless as the product itself, as the tags on the zips kept falling off!

<h3>iPhone</h3>

Ok, so I'll start this off with a disclaimer: what follows is all my own opinion, formed during the talk; it may not match your own experiences :-) 

I like Apple's products - I couldn't live without my iPod Nano - and I still use my old G4 iBook I had at University, even if it is slowly packing up.  OS X is a good operating system, although it sounds like Snow Leopard would be best shuffled under the carpet (or maybe turned into one :-) 

I don't (currently) own an iPhone because it's waaaaaaaaaaay out of my price range, but having played with a couple and compared it with other devices, it does seem that the iPhone 3GS is the best-available smart phone today (in spite of its faults, like the camera, and the lack of support for background processes, and...)

However, it's painfully obvious that Apple's focus is not development.  Whilst the XCode IDE seems like quite a good product, the Objective-C language takes all those conventions and improvements in language design that have been built up over the last n years and throws them out the window.  There's an old joke that the only valid measurement of code quality is the number of WTFs/minute scored when reading it: 

[img_assist|nid=117|title=Code Quality|desc=The only valid measurement of code quality is WTFs/minute|link=url|url=http://www.osnews.com/story/19266/WTFs_m|align=center|width=500|height=471]

Note even the good code has a couple :-)  The problem with Objective-C is that the programming language is itself a source of WTFs.  Take this code snippet for example:

<blockcode language="objc">
@interface SomeClass : NSObject
{
    -(void) setName:(NSString*) newName;
}
</blockcode>

Intuitively, you might expect to be defining an interface, a high-level abstraction to a class.  Instead, that @interface keyword is completely misleading, and the code snippet instead defines a class (an interface is defined using the @protocol keyword, apparently).  Furthermore, this is a header file; the implementation of the class is stored separately, just like C/C++.

Another snippet, this time to initialise, use and dispose of an object:

<blockcode language="objc">
SomeClass* c = [[SomeClass alloc] init];
[c setName: @"elephant"];
[c release]
</blockcode>

What's that?  Manual memory management?  Pointers?  <strong>*Shudder*</strong>. If this were supposed to be a C++ equivalent, I'd be less worried.  However, Objective-C is pitched as a fully modern language up there with C# and Java and it won't even manage memory for you?  Modern languages are supposed to abstract away these concerns to make developers more productive. 

Apple have done themselves no favours by adopting the Objective-C language; whilst the Android talk required no introduction to Java to discuss the topic, Phil Nash spent twenty minutes providing a basic introduction to Objective-C before we could even get on to the iPhone-specific stuff.  This meant that we didn't cover much in terms of the device's capabilities at all, unlike the Android talk. 

I had high hopes for this talk and genuinely wanted to learn about iPhone development, but instead I got a tutorial on Objective-C.  For me at least, iPhone development appears to be a big bag of FAIL.

[<strong>Note</strong>: I think I've fucked up the code samples, as GeSHI is failing to correctly syntax-highlight them.]

<h3>Jon Skeet</h3>

Jon Skeet, Googler, MVP, and most importantly the top user on Stack Overflow with a whopping reputation of 111,451 [at time of writing - Ed.] gave a thoroughly entertaining talk rant on the problems humanity has created for developers.  You can read the <a href="http://msmvps.com/blogs/jon_skeet/archive/2009/11/02/omg-ponies-aka-humanity-epic-fail.aspx" title="OMG Ponies!!! (Aka Humanity: Epic Fail)">full transcript</a> on his blog, and a <a href="http://vimeo.com/7403673">video</a> is also available.

Topics covered included rounding errors, the different semantic interpretations of numbers (e.g., £5.50 vs 5.50kg), line breaks, the Turkey test, time and time zones.  If you fancy a laugh, check it out :-)

<h3>How not to design a scripting language</h3>

Paul Biggar from Trinity College Dublin filled the "Graduate Student" slot at the London event.  His slides (with speaker notes) are available here. There's not a great deal to say on this talk, as it was entirely theoretical.  Some of the theory had practical implications of course, with Paul focussing on Python (for no good reason; he could equally have chosen Ruby, for example). 

<h3>Yahoo! Developer! Tools!</h3>

I'll say this about Christian Heilmann, Developer Evangelist at Yahoo!: he's an excellent presenter, but it's impossible to take notes because he moves at lightning speed.  His slides also contain little to no content, consisting mostly of <a href="http://icanhascheezburger.com/2009/11/03/funny-pictures-pumpkins/">lolcats</a> :-)  What follows is therefore based on my memory of the talk, which is fading quickly. 

Christian gave an excellent overview of Yahoo!'s developer tools, including YUI (a JavaScript library similar in intent to jQuery; he did some not-too-subtle jQuery bashing in the process) and Grids (for creating CSS layouts using a visual designer).  The most powerful tool he demonstrated, however, was <a href="http://developer.yahoo.com/yql/">YQL</a>, the Yahoo Query Language.  This tool is effectively SQL for The Internet; it pulls together the various different APIs exposed by the multitude of applications available on the web and allows you to cross-reference and "mash-up" the content returned.  Heilmann's own <a href="http://www.wait-till-i.com/">homepage</a> is completely constructed from YQL queries and the Yahoo! Grid tool.  Here's a simple YQL query to retrieve my TweetStream:

<blockcode language="sql">select * from twitter.user.status where id='alastairs'</blockcode>

It's also worth mentioning that having seen Christian talk at the <abbr title="Future of Web Apps">FOWA</abbr> Tour in Cambridge on YQL, little of this talk was new to me.  After about the third or fourth time, the content might get a bit dull (even if he is an entertaining speaker).  

<h3>Conclusion</h3>

The London Dev Day was a huge success, and for me personally very interesting. I picked up a number of topics about which I know very little (Python, jQuery) or nothing (iPhone, Android).  I'm a big fan of having a breadth of knowledge as well as a depth of knowledge, and that is one of the things the Dev Days idea promotes most strongly. I will definitely be going again next year, and I would strongly recommend it to anyone even vaguely interested in going.
