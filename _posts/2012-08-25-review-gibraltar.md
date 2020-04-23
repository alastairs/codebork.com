---
layout: post
title: 'Review: Gibraltar'
author: alastairs
nid: 214
created: 1345889184
---
A couple of weeks ago, I was invited by [Rachel Hawley](http://www.twitter.com/RachelHawley) to take a look at the latest version of [Gibraltar](http://www.gibraltarsoftware.com/), a real-time logging and error analysis solution. Gibraltar was recently updated to v3.0, and I'd been meaning to look at it in more detail for [GiveCRM](http://www.givecrm.org.uk/) for a while, so figured this was an opportunity I wanted to take up.

<!--break-->

Before I begin, in the interests of full disclosure, I should say that I was asked to write this piece, and that I have worked on GiveCRM closely with [Kendall Miller](http://www.twitter.com/kendallmiller), Principal at eSymmetrix who sell Gibraltar.  I have been offered a personal licence for Gibraltar in return for writing this post.

With that out of the way, let's begin.  I had no experience of Gibraltar before this week, and given the nature of the product I was concerned that it might take a fair bit of configuration to set up.  I'm very glad to say that this was not the case at all: installation of Analyst is a breeze, and setting up a Hub is as simple as filling out a few fields on a web page.  

Wait, Hub what? Analyst who?  You're right, I need to back up a bit and lay down some detail.  

## These ain't yo' Mama's diagnostics

Gibraltar is a product that provides real-time feedback on errors that occur in your application.  The most basic high-level description of it that I can come up with is that it is logging on steroids: rather than just dumping log messages (or, worse, exceptions) to a log file or database table, Gibraltar packages up events and errors in your application in such a way that you can get real information out of them. No more log file parsers, and hours of combing through the detritus of your application: just cold, hard facts pointing to the specific failures. Failed configuration? Assembly loading problems? Gibraltar has your back.

Gibraltar is formed of three parts:

  * The *Agent* collects data from your application and sends it to the Hub.  This must be added to your application prior to deployment.
  * The *Hub* stores the data and forwards it onto one or more Analysts.  This is a cloud-based service offered by Gibraltar, but you can also run your own Hub if you prefer (and at an increased price).
  * The *Analyst* provides insight into the data collected.  This is a desktop application you must install on your development box (or similar).  

This short introductory video covers the detail quite nicely.  

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/oK1g-jkBiws" frameborder="0" allowfullscreen></iframe>

##  Configure all the things!
 
As I said above, configuring and setting up Gibraltar is actually really simple.  The Hub is optional, but I recommend giving it a go (it sure beats having all your packages emailed to you); furthermore, the cloud Hub is so ridiculously easy to set up, it's harder *not* to use it.  Analyst is a simple MSI installer and runs great on my Windows 8 machine.  

Configuring Agent is a little more involved, but still crazy simple. Fire up Analyst and click the ginormous green button inviting you to add Gibraltar to your application:

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarHomeScreen_0.png" width="600" />

This launches the Agent configuration wizard, which walks you through six screens to add Gibraltar to your app.  One feature I particularly like about this wizard is that you can point it at an existing binary, or a Visual Studio project file:

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarWizard1.png" />

As you might expect, one of the later steps offers you the opportunity to hook Gibraltar up to a Hub, but the inclusion of that "Test" button is a real nice touch. How many times have we provided all the details for a remote server, only to find after configuration that we made a typo somewhere?  No?  Just me, then.

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarWizard4.png" />

Once the wizard is complete, you'll find that Gibraltar has added a reference to the Agent assemblies to your project file (and saved a back-up of the project file, another nice touch), and modified your [app|web].config file.  Here are some of the changes made to GiveCRM's web.config after I enabled Gibraltar on there:

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarWebConfig.png" width="600" />

There's also a bunch of stuff done in the `<healthMonitoring>` section to hook into ASP.NET's infrastructure.  

## A gathering storm

With the Agent configured, you can fire up your application, and Analyst, and take a look at the data collected.  If you're using Gibraltar in a desktop application, you can also hit Ctrl+Alt+F5 to bring up a live diagnostics window on the application, [which seems *really* cool](http://www.gibraltarsoftware.com/See/Record.aspx).  It would be awesome if a JavaScript-based version of this could be brought up on a Gibraltar-enabled website too.  

A nice feature of Gibraltar is that it includes details of the session that caused the error: which user account was running the application, how long the session lasted, what OS it was running, how many cores and how much memory the machine was sporting, and more.  

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarSessionDetails.png" width="600" />

This would be great for auto-populating bug reports, and what do you know, Gibraltar integrates with FogBugz and Gemini.  However, I'd like to see more integrations with other products, such as Atlassian's JIRA, and GitHub's Issues, or perhaps even services such as UserVoice.  

## Analyse This

Beyond poking into your application's errors, Gibraltar will provide some insight into key metrics on your application.  Note that these need to be application event metrics, such as page hit metrics like request duration.  

<img alt="Add Gibraltar to your app" src="http://codebork.com/sites/default/files/GibraltarCharting.png" width="600" />

For some reason, the standard Windows Performance Counters (such as total processor time and available memory) are included here too, but you can't create a chart from them.  On further investigation, I found that if you chose to create a *graph* rather than a *chart*, then you can plot those too.  I would prefer in each of those views to only have those metrics that can be plotted by the view selected, rather than all of them available, or at least some indication why I can't create a chart of processor time.  

I suspect that this mechanism could be extended to allow you gain some (anonymised) insight into your users' behaviour in your application: which features are used most, which are used least, which need more optimisation, etc. It's not immediately clear that this is the case, but I think it would'nt be too hard to put in a new Windows Performance Counter that fired when a feature was activated, with the name of the feature.  This is something we might like to do with GiveCRM, so that we can get a feel for how to develop the product; there is also a strong use case for doing something similar in the SaaS platform part of the product to identify pain points in the administration functions, and monitor performance of the platform.  

## Conclusion

In my limited playing with Gibraltar so far, I have seen potential in it, but no real use yet.  This is, in part, because GiveCRM is not live, and so I was only able to collect data from local sessions whilst debugging the application. As a result, the exceptions thrown (and logged by Gibraltar) tended to cause Yellow Screens of Death that I was able to troubleshoot directly.  However, I see a lot of value in this approach to error logging and analysis, and so look forward to an opportunity to use it in a live application and appreciate its real value in building quality software.  
