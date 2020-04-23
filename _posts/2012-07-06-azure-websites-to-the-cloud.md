---
layout: post
title: 'Azure Websites: To the Cloud!'
author: alastairs
nid: 195
created: 1341603920
---
When [Scott Guthrie](http://www.twitter.com/scottgu) and team unveiled the new Windows Azure updates back at the beginning of June, one of the most trumpeted features was the new Azure Websites feature, which brings to the Azure platform a service provided by [AppHarbor](http://www.appharbor.com/) and [Heroku](http://www.heroku.com/) (for the Rubyists): simple hosting of websites on a cloud platform.  One of the killer features of these platforms, and now Azure Websites, is simple deployment to the cloud via git push.  AppHarbor in particular does a good job of this in the .NET space, building your project and running the tests before deciding whether or not to deploy that commit.  They have some serious competition from Azure now, though.  

<!--break-->

I'm using Azure Websites to develop (and, ultimately, host) the new [Cambridge Graduate Orchestra](http://www.cambridgegraduateorchestra.com/) website, and have so far found the experience impressive.  Whilst I'm familiar with Git-based deployment from previous usages of both AppHarbor and Heroku, I'm pleased to see Microsoft actively supporting more open-source tools and technologies in its products and services.  Whilst the Azure Websites service is not as mature as AppHarbor's offering, the combination with other Azure features, such as the Azure Service Bus and the new Infrastructure-as-a-Service bits, makes it a compelling option.  

The first thing you'll need to do is log in to (or sign up for) a free trial of Azure.  Once you've logged in, go to the Azure Portal; if you get the old grey portal, look for and click the link to the new preview portal at the very bottom of the screen.  

Next create a new Azure Website. Click new:

<img src="http://codebork.com/sites/default/files/Create%20Website.png" alt="The new Windows Azure Portal, illustrating how to create a new Azure Website" title="Create a new Azure Website" height="540" />

After you hit "Create Web Site", you'll see the new website appear in the list as configuring; it will say "Running" when it is ready for use, and you'll see a green tick next to it (like the CGO site in the above screenshot).  

Next, click the site to be taken to its dashboard.  This is where you can view all sorts of metrics about your site, including requests, storage, CPU time and more.  Click the link that says "Set up Git publishing":

<img src="http://codebork.com/sites/default/files/Dashboard.png" alt="The new Windows Azure Portal, illustrating where to click to set up Git publishing." title="Set up Git publishing" height="540" />

This will prompt you for a username and password to use for connecting to Azure via Git.  This is created on a <em>per-account basis, not on a per-site basis</em>, so you only need to do this once.  You'll then get a Git URL with some instructions on how to use it:

<img src="http://codebork.com/sites/default/files/Git%20instructions.png" alt="The new Windows Azure Portal, illustrating the instructions provided to help you set up your local Git repository for publishing to Azure." title="Git instructions for publishing" height="540" />

Add a new remote to your existing Git repository, and run `git push azure master`. Simplez.  At the moment, only the master branch is supported for deployment; if you are using a different branching convention, you will receive an informational message stating this.  

The <strong>really nice thing</strong> about this is that after Azure builds your pushed repository, it will generate an MSDeploy package from it, and run a deployment using that package.  That means you can take advantage of all the nice things, like configuration file transforms, that you get with MSDeploy.  

I'm really impressed with the job Microsoft has done here, and look forward to delving more into this in the coming weeks.
