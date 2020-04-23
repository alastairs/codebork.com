---
layout: post
title: More on Message Passing!
author: alastairs
nid: 41
created: 1220913911
---
I recently posted a question to <a href="http://www.stackoverflow.com/" title="Stack Overflow">Stack Overflow</a>.  This is a great developer community site run by <a href="http://www.codinghorror.com" title="Coding Horror">Jeff Atwood</a> and <a href="http://www.joelonsoftware.com" title="Joel on Software">Joel Spolsky</a> that's currently in private <a href="http://beta.stackoverflow.com" title="Stackoverflow Beta">beta</a>.  It's a good mixture of discussion forum, <a href="http://www.digg.com">Digg</a>-style ratings' site, and wiki that promises to become a truly invaluable resource once development is complete; it's well on its way already!  The idea is that ordinary developers post questions and the community responds, with both questions and answers being voted upon by the community.  

I've included my question below to gain the issue a bit of extra exposure.  If you have a stackoverflow.com account, please visit <a href="http://beta.stackoverflow.com/questions/50822/message-passing-in-a-plug-in-framework-problem" title="Message Passing in a Plug-In Framework Problem">my question</a> and post a response there, or vote on the question and any existing answers.  Alternatively, please leave a comment on this post with your thoughts.
<!--break-->
<hr />First off, there's a bit of background to this issue available on my blog:
<ul>
<li>http://www.alastairsmith.me.uk/coding/2008/06/25/message-passing-a-plug-framework.html</li>
<li>http://www.alastairsmith.me.uk/coding/2008/07/31/message-passing-2.html</li>
</ul>

I'm aware that the descriptions in those posts aren't hugely clear, so I'll try to summarise what I'm attempting as best I can here.  The application is a personal finance program.  Further background on the framework itself is available at the end of this post.

There are a number of different types of plug-in that the framework can handle (e.g., accounts, export, reporting, etc.).  However, I'm focussing on one particular class of plug-in, so-called data plug-ins, as it is this class that is causing me problems.  I have one class of data plug-in for accounts, one for transactions, etc.

I'm midway through a vast re-factoring that has left me with the following architecture for data plug-ins:
<ul>
<li>The data plug-in object (implementing intialisation, installation and plug-in metadata) [implements <code>IDataPlugin<FactoryType></code>]  </li>
<li>The data object (such as an account) [implements, e.g., <code>IAccount</code>]  </li>
<li>A factory to create instances of the data object [implements, e.g., <code>IAccountFactory</code>]</li>
</ul>
Previously the data object and the plug-in object were combined into one, but this meant that a new transaction plug-in had to be instantiated for each transaction recorded in the account which caused a number of problems.  Unfortunately, that re-factoring has broken my message passing.  The data object implements <code>INotifyPropertyChanged</code>, and so I've hit a new problem, and one that I'm not sure how to work around: the plug-in object is registering events with the message broker, but it's the data objects that actually fires the events.  This means that <strong>the subscribing plug-in currently has to subscribe to each created account, transaction, etc.!</strong>  This is clearly not scalable.  

As far as I can tell at the moment I have two possible solutions:
<ol>
<li>Make the data plug-in object a go-between for the data-objects and message broker, possibly batching change notifications.  I don't like this because it adds another layer of complexity to the messaging system that I feel I should be able to do without.   </li>
<li>Junk the current event-based implementation and use something else that's more easily manageable (in-memory WCF?!)</li>
</ol>
So I guess I'm really asking: 
<ol>
<li>how would you solve this problem?</li>
<li>what potential solutions do you think I've overlooked?</li>
<li>is my approach even vaguely on-track/sensible?! :-)</li>
</ol>
Many thanks in advance for the time and effort you put into your responses.  As you will be able to tell from the dates of the blog posts, some variant of this problem has been taxing me for quite a long time now!  As such, any and all responses will be greatly appreciated.  

The background to the framework itself is as follows:  
<blockquote>My plug-in framework consists of three main components: a plug-in broker, a preferences' manager and a message broker.  The plug-in broker does the bread-and-butter plug-in stuff: discovering and creating plug-ins.  The preferences' manager manages user preferences for the framework and individual plug-ins, such as which plug-ins are enabled, where data should be saved, etc.  Communication is via publish/subscribe, with the message broker sitting in the middle, gathering all published message types and managing subscriptions.  The publish/subscribe is currently implemented via the .NET <code>INotifyPropertyChanged</code> interface, which provides one event called <code>PropertyChanged</code>; the message broker builds a list of all plug-ins implementing <code>INotifyPropertyChanged</code> and subscribes other plug-ins this event.  The purpose of the message passing is to allow the account and transaction plug-ins to notify the storage plug-ins that data has changed so that it may be saved.</blockquote>
