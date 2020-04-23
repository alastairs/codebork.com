---
layout: post
title: Automating TeamCity (Part 1 of n)
author: alastairs
nid: 225
created: 1353802730
---
Recently at work I have been working on a project to build out a new TeamCity installation on a small farm of servers.  Having drawn some inspiration from [Paul Stack](http://www.twitter.com/stack72), I knew that leveraging a virtualised environment could buy us some big wins in automating many aspects of the new TeamCity environment.  This post begins a series of posts that will describe in some detail what I set out to achieve, why, and how I did so.  

## Motivation

At work, we currently have a number of TeamCity installations, ranging from the very small to somewhat larger: our smallest installation consists of a TeamCity server and a build agent all installed on a single machine, whilst the largest consists of a TeamCity server on one machine and a mixture of physical and virtualised buildagents to a total of eight agents.  The initial motivation for the project was to consolidate these environments into a single larger environment to reduce administration overheads and remove silos of builds and their artefacts.  

I had previously done some work to create a Virtual Machine (VM) template for the build agents in our main TeamCity installation, with some success: setting up a new bulid agent from scratch used to be a day's work, and with the VM template that time initially came down to 10 minutes or so.  Unfortunately, the template was a little fragile in the way it had been set up: for example., a PowerShell script that ran on boot would not always run, and the use of an answer file for Windows setup turned out to be a poor choice. Furthermore, over time the template only became more out of date as we made changes to our product and infrastructure, particularly in moving from Subversion to Git.  It was still much faster to create new build agents than it used to be, however, not least because we didn't have to wait for an old developer machine to become available, and when we bought another five build agent licences a couple of months ago, I was able to get the new VMs set up from this template in a few days. 

We also wanted to set up a new domain on an isolated subnet for the new TeamCity infrastructure.  We have approximately 25000 tests in our main product, and sadly many of these are poor tests: in particular, there is a large number of tests that hit the underlying database for our product, and some hit the company's Active Directory.  Coupled with the network problems we have historically suffered (thankfully now mostly resolved!), it is sadly not uncommon to see spurious test failures because some component of these system tests could not be contacted. By placing TeamCity on its own domain, isolated from high traffic of the main network, it is hoped that these tests will become more reliable.

After talking with Paul months ago, and in feeling some of this pain, I realised that putting everything into the template was not a sensible decision, and something more configurable was required.  Paul had described how he had scripted the configuration of his build agents, to the extent that he could click "Run&hellip;" on a particular build configuration in TeamCity, and have a new build agent ready a few minutes later.  This sounded like a really cool thing to be able to do, and coupled with a requirement from my colleague [Adrian](http://www.twitter.com/adrianbanks), namely that we be able to regenerate the build agents on a weekly or monthly basis to keep them clean and free of cruft, Enter the power of automation.  

## The Plan

A plan was forming in my mind.  Onto each of the five new servers we had bought for this purpose, I would install Citrix XenServer, an Enterprise-class Server Virtualisation product I was familiar with from my time working at Citrix.  The servers would be joined together into a pool so that VMs could freely move around them as necessary.  We would need some form of shared storage for the XenServer pool to store its VM templates.

The VM templates themselves would be very slim: the minimum required software would be installed.  For a basic build agent, this meant Windows Server 2012 plus the TeamCity Build Agent software.  Further templates would be required for .NET 4.0 build agents and .NET 4.5 build agents, so that they could include the appropriate Windows and .NET SDKs.  I would be very strict about what could be installed onto a build agent template and what could not, and pretty much everything could not.  

Using the might of PowerShell, we would script the installation of dependent software onto a new build agent VM; Chocolatey (built on the popular NuGet package manager) would be of use here.  Ideally, we would script the configuration of the build agent machine as well: set the computer name, join it to the domain, and more.  

The final piece of the puzzle was TeamCity itself. We would need to set up a set of build configurations to automatically delete and re-create all the build agents currently running, and to allow for the creation of a single new build agent.  We would also use this as the NuGet package source for our custom Chocolatey packages. 

### List of Tools Used

  * Citrix XenServer 6.1 (free edition)
  * FreeNAS (shared templates over iSCSI)
  * Windows Server 2012
  * PowerShell 3.0
  * PowerShell SDK for Citrix XenServer 6.1
  * Chocolatey 
  * and, of course, TeamCity

## Part 1 Wrap-up

Hopefully this post has made clear the motivation for this project, and some of the requirements involved.  When we set out, I was confident that, although the end result sounded more than a little utopian, the goals could be achieved.  I'm glad to say that with a lot of research and tinkering, and hard work to get the bits working in production, it *is* possible to achieve that utopian state, and it's pretty cool to see it happening.  The detail of the solution will be covered in future posts.  
