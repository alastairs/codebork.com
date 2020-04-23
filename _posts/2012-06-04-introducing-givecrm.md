---
layout: post
title: Introducing GiveCRM
author: alastairs
nid: 182
created: 1338817778
---
Compulsory opening statement: It's been a little while since I last blogged, and there's a level of irony in that fact because now I have rather more to blog *about* than I did before.  In the last few months I've been working with a small handful of guys from my [GiveCampUK](http://www.givecamp.org.uk/) team to launch [GiveCRM](http://www.givecrm.org.uk/).  Whilst we were all quite fired up to be working on it over the course of the GiveCampUK weekend, not everyone wanted to carry on with it beyond that event, and not everyone has had time to dedicate to it.  Such is the nature of open source, I guess.  
<!--break-->
## What is GiveCRM?
 
GiveCRM is a Customer Relationship Management (CRM) system for charities and other non-profit organisations.  It has a focus on exceptional ease of use, and is designed explicitly for the needs of the non-profit sector.  Using GiveCRM, you can manage details of donors and other members of your organisation, record donations made, track campaigns to drive donations and see what donations resulted from which campaign.  **Note:** we do not enable accepting donations online, only the recording of the donated amount against a particular person.

We're building on ASP.NET MVC 3, with plans to move to MVC 4 in the near future.  The code is all C#, and we've used Twitter Bootstrap to develop v1 of our user interface, and Simple.Data to handle our data access.  We're developing a Software-as-a-Service (SaaS) product with a monthly fee to cover our hosting costs, but we also provide a standalone version of the application for charities who need or wish to deploy a private instance.  

You can find and fork the source code on [GitHub](http://www.github.com/givecampuk/givecrm/).  Send us a Pull Request for one of our [open bugs or features](http://www.github.com/givecampuk/givecrm/issues).

## Why are you blogging about this now?

Development has picked up again recently on the project, and we've hit a couple of interesting design points along the way.  Chief among these is our multi-tenancy strategy for the SaaS product, where we host multiple customers on one box.  I'll be talking about these more in future posts.  
