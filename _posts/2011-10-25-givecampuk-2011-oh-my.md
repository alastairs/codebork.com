---
layout: post
title: "#GiveCampUK 2011 - Oh My"
author: alastairs
nid: 177
created: 1319574481
excerpt: !ruby/string:Sequel::SQL::Blob 'I am going to open this blog post with a
  bold statement: GiveCamp UK was one of the greatest experiences of my life.  Here''s
  my story. '
---
Friday 21 October : "Sleep is a weapon"
---------------------------------

I took Friday off work, did a spot of shopping in the morning, and hopped on a train down to London.  Thank god the hotel and the venue were so close to Kings Cross; it was an absolute lifesaver not having to battle the Tube etc.  Checked into the hotel, relaxed for a bit before meeting [Adrian](http://www.adrianbanks.co.uk/), then wandered over to [UCL](http://www.ucl.ac.uk/) to register.  

A little while later (we turned up quite early), the event got under way with an introductory talk from [Rachel](twitter.com/rachelhawley) and the charities introducing themselves and their requirements.  Many of the [projects](http://www.givecamp.org.uk/blog/introducing-our-givecamp-uk-2011-charity-projects/) sounded really interesting!  We then had the opportunity to mix with other volunteers and the various charities to decide which project we wanted to work on.  I spent some time milling around, but the two projects I was particularly interested in were the CMS/repository of resources for the [Charity Technology Trust](http://www.ctt.org/) and the [Nathan Timothy Foundation](http://www.nathantimothyfoundation.org/)'s site to aggregate their various items of content.  I was curious too about the wildcard project, which intended to build phase one of an open-source <abbr title="Customer Relationship Management">CRM</abbr> geared towards simplicity, and purpose-built for the voluntary sector.

This "mixer" session was one of two bits of GiveCamp that didn't really work for me.  It seemed that the choice of projects was quickly reduced before the session really got started:

* One project team had selected their technology before GiveCamp even started, and it was one with which I was unfamiliar (node.js).  I was quite interested in this project and it was a bit of a shame to have to discount it. Mind you, I'm not sure I could have coped working with Gary Short and Rob Ashton ;-)
* Another project team seemed to be fully-assembled by the time I got to them, to the extent that they had started work!  It seemed like I'd have a fair bit of catching up to do if I wanted to join that team.
* One charity had specified they want to work with WordPress.  I've done enough PHP to know I don't want to touch it again if I can help it.  

After doing the rounds and spending some time in the discussion on the wild-card project with Kendall Miller, it became obvious which project I was going to pick.  Kendall has great energy and enthusiasm, and I figured that was something we were going to be in need of at 3am Saturday night when nothing worked. (Thankfully, it didn't come to that!)  

We started going over the full *half-page* of requirements and working out how we wanted to tackle the solution.  Whilst the aim was a free open-source CRM aimed at charities, what we decided to go with was a cloud-based <abbr title="Software as a Service">SaaS</abbr> solution that would be super-simple to deploy: you just can't beat the power of the cloud for making deploying an entire system easy.  The CRM needed to be able to import data from Excel to make it easy for charities to get their existing data into the system.  The CRM had to be able to manage campaigns, donations and members, and much more besides.

(**Aside:** This was the second bit of GiveCamp that didn't quite work for me. All teams were discussing their projects in the very echoey hallway/corridor that was our base for the weekend, and it made it *really* difficult to hear half the discussion. It would have been useful if we'd had separate rooms for the project teams at this point. Luckily Kendall had a loud voice!)

And with that, **[GiveCRM](http://www.givecrm.org.uk/) was born!**  We started dividing up the work: one team would work on the back end database, one team would work on an API for importing and exporting data from Excel, one team would work on the setup and provisioning site, and one team (the largest) would work on the core CRM web app.  With our billets posted, we broke up to go start planning our teams' work.  

Here's one of the things I loved about GiveCamp: when discussing what technologies we were going to use, someone threw an idea out there (e.g., ".NET 4.0", "ASP.NET MVC 3", "Git", etc.), and unless someone had a particular problem with it (which no one did), we just went for it. No lengthy evaluations, no dithering, just good swift decision making. Kendall was exceptionally good at keeping up the momentum on the decision making all weekend, which meant that we were able to execute massively faster than I had thought possible.  

I was working with [Robin Minto](http://www.twitter.com/robinem) on the setup/provisioning side of things.  We spent our time in the excellent [Balsamiq mock-ups](http://www.balsamiq.com/), figuring out what the minimum required information was that we needed to set up a site, and constructing a workflow for the provisioning process.  We were later joined by [Ben Scott](http://www.twitter.com/bpscott), a web developer, who provided invaluable expertise in constructing these mock-ups.  

<a href="http://codebork.com/sites/default/files/Setup%20UI.png" title="Large version of Setup UI mockup"><img src="http://codebork.com/sites/default/files/Setup%20UI.png" alt="Setup UI mockup, a two-stage process" title="The two-stage GiveCRM setup process" width="700" /></a>

<a href="http://codebork.com/sites/default/files/Setup%20UI%202.png" title="Large version of Setup UI mockup with validation error messages."><img src="http://codebork.com/sites/default/files/Setup%20UI%202.png" alt="Setup UI mockup with validation error messages" title="The second step of the set-up process" width="700" /></a>

<a href="http://codebork.com/sites/default/files/Data%20Import%20UI.png" title="Large version of Data Import UI mockup"><img src="http://codebork.com/sites/default/files/Data%20Import%20UI.png" alt="Data Import UI mockup" title="The data import UI." width="700" /></a>

Whilst the two UI teams were discussing UX design, simplicity, etc., the database and Excel teams were beavering away working to create something we front-enders could build on the following day.  A big thanks to [Chris Diver](http://www.twitter.com/chrisjdiver), [Anthony Steele](http://www.twitter.com/AnthonySteele) and [Mark Rendle](http://blog.markrendle.net/) for getting us set up with a SQL database, dummy data to go in it, and a Simple.Data data access layer over the top, respectively; and to [Nathan Gloyn](http://designcoderelease.blogspot.com/) and [Johan Barnard](http://www.twitter.com/johanbarnard) for building a really nice, fully-tested API for working with Excel spreadsheets (and taking my improvement requests the following day).  Great work guys!

Around midnight, we retired to catch some precious sleep before starting in earnest shortly after 8am the next day.  

Saturday 22 October : "We've resorted to using a physical token to 'lock' items in Git"
-----------------------------------------------------------------------

I woke up shortly before my alarm went off at 7am, dreaming about the solution we were going to implement and some of the problems we had to solve. No, really I did.  We arrived back at GiveCamp shortly after 8am, I swear the earliest time I have been at University in my life (even earlier than [DDDs](http://www.developerdeveloperdeveloper.com/)!).  What greeted us there, however, was a feast: bacon and sausage baps/batches/rolls, muffins, pastries, croissants, pains au chocolat, tea, coffee...  We sure weren't going to go hungry or thirsty this weekend!

By 9.30 or so, we'd divided up the development tasks amongst ourselves.  This was where things started to get interesting.  It soon became clear that my laptop was not happy and that my development VM was borked: no network connectivity in or out was going to make it very difficult indeed to work on anything at all (thanks, Parallels).  That would have been game over for me, had Kendall not stepped in and lent me his laptop for the weekend.  The guy is a legend.  

A larger problem for the team was our use of Git.  It was clear (unfortunately, only in hindsight) that we were using the wrong workflow for a distributed version control system, and everyone committing to master and pushing and pulling from the same remote repository resulted in us having to repeat a fair bit of work.  We probably lost a good couple of hours' work to our Git problems.  Robin had to repeatedly blow away his local repository and re-clone from the remote.  The main issue for us was conflicting changes in the csproj and sln files.  We ended up solving this in the time-honoured tradition of centralised version control systems: a MUTEX lock.  (This is how, in hindsight, it's obvious we were following the wrong workflow.)  Interestingly, at least two other teams had the same issue.  Git sadly got very little love that weekend.  

Another problem for us was conflicting changes to the database project (and the database itself).  This we solved more practically: Chris set up the database on his laptop, and Kendall ordered us an 8-port switch so we could all connect to Chris' database.  Less than an hour later, it arrived, and the problem was instantly solved.  

Lunch was a super-tasty burrito provided by [Luardos burrito van](http://luardos.co.uk/).  Check them out, their food was *really* good!

By about 3.00pm, after a singularly frustrating morning with little perceived progress, stuff suddenly started coming together.  The pace ramped up throughout the rest of the day: feature after feature slotted in to place.  Throughout the day, I was working on the import-from-Excel functionality that is a key part of the setup story.  I was quite happy with how this work progressed, as I was able to implement the feature with relatively good test coverage (not great, mind; something I'm now rectifying) and following best practices like dependency injection.  

That evening, Kendall found a wandering designer from [VerseOne](http://www.verseone.com/) to create us a logo:

<img src="https://github.com/downloads/GiveCampUK/GiveCRM/GiveCRM-icon.png" alt="GiveCRM Logo" title="GiveCRM logo" width="700" />

I later discovered that I had implemented the Excel importer in the wrong place: I had been thinking of it in terms of the setup process, so implemented it in GiveCRM's Admin site (where charities can sign up to GiveCRM, have their instance created, etc.).  In fact it's part of GiveCRM itself, where charities can add and manipulate their own data.  That was going to have to be a task for Sunday morning, if it got done at all.

Sunday 23 October : "Down to the wire - I know because we're now saying 'nope, don't even try that.'"
---------------------------------------------------------------------------------

I woke up shortly before my alarm went off at 7am, dreaming about the solution we were going to implement and some of the problems we had to solve. This time, I also felt hungover (although no alcohol had been consumed since Thursday night): the caffeine and sleep deprivation was starting to take its toll.  

I rolled into UCL a little later than the previous day, at about 8.30am.  We were again greeted by the same breakfast feast as Saturday, and we soon agreed the concept of "breakfast pudding" was a Good Thing™.  

All development had to stop at midday Sunday, so we were now coding against the clock. The sugar and caffeine injection, combined with the adrenaline of working to this deadline, left me a little bit buzzy:

[I'm so tired, I woke up feeling hungover. I need the largest, strongest cup of tea ever right now. ](http://twitter.com/#!/alastairs/status/128006276365033472)
[Called in the big guns: two cups of tea at once.](http://twitter.com/#!/alastairs/status/128013278289985537)
[Chain drinking tea. It's all good.](http://twitter.com/#!/alastairs/status/128017338283991041)
[Phrase of the weekend, as coined by @nbarnwell: Breakfast Pudding.](http://twitter.com/#!/alastairs/status/128020255183355904)
[Feeling a bit *too* enamoured with this carrot cake muffin. The lack-of-sleep madness is starting to set in.](http://twitter.com/#!/alastairs/status/128022586339758082)
[I saw my two cups of tea and raised it a bottle of water.](http://twitter.com/#!/alastairs/status/128038996319285248)
[Busy busy busy. And buzzy buzzy buzzy.](http://twitter.com/#!/alastairs/status/128055270327853056)

I had a few bits to finish off with the import work, such as integrating it with the main site (tricky, given that it was in the wrong bit of the site) to produce a smooth demo, and add the final polish.  With regular progress checks throughout the morning, but ultimately with some time to spare, we were done: 

[...and that's it. End-to-end demo WORKS. I am so proud of the work we've completed this weekend.](http://twitter.com/#!/alastairs/status/128069253420167168)

We spent a bit of time practising our demo and taking team photos before lunch, which turned out to be a truly excellent hog roast.  Later, we moved across the road to UCL's Cruciform Building, a large red-brick building, for the demos.  

Everyone had made excellent progress with their projects over the GiveCamp weekend, and this came across in the demos presented.  Massive respect to the team working with the YouCan Hub for *going live* that weekend, and to Dylan Beattie's team working with Scene and Heard UK who completed the brief on **Friday night** and worked with the charity to build out a whole bunch of other stuff for them.

<a href="http://www.flickr.com/photos/bertcraven/6273846394/in/photostream" title="The GiveCRM demo, on Bert Craven's Flickr Stream"><img src="http://farm7.static.flickr.com/6096/6273846394_bfc3260a9e_z.jpg" alt="The GiveCRM demo" title="The GiveCRM demo" /></a><br />
<span style="font-size: small">Photo copyright &copy; <a href="http://www.flickr.com/photos/bertcraven/">Bert Craven</a> 2011. Used with permission.</span>

Thank yous
----------

I've marked links in bold where I or my team used a product or service from that sponsor over the course of the weekend. An extra-special thanks to them!

### Sponsors ###
 * [EduServe](http://www.eduserv.org.uk "Technology solutions that save money for the education, health and public sectors as well as commercial organisations.")
 * [SQLBits](http://sqlbits.com "Over 200 hours of SQL Server video content from our past conferences, available free at SQLBits.com, featuring expert speakers from around the world.")
 * **[Gibraltar Software](http://www.gibraltarsoftware.com "Gibraltar is an affordable, effective, end-to-end solution for logging, error management, and application monitoring")**
 * [InFusion](http://www.infusion.com "Infusion solves business problems by combining expert software engineering with appealing user experiences and design")
 * **[Red Gate](http://redg.at/mnm95h "Red Gate Software makers of simple tools for Microsoft developers, DBAs.")**
 * [FusionIO](http://www.fusionio.com/ "The Fusion-io storage memory platform significantly reduces latency and improves the processing capabilities within a datacenter by relocating active data from centralized storage to the server where it is processed.")
 * [Black Marble](http://www.blackmarble.com/ "Black Marble Software Consultancy and Development West Yorkshire. Covering Leeds, Bradford, Halifax, Huddersfield, West Yorkshire and the North of England.")
 * [JustGiving](http://www.justgiving.com "JustGiving (www.justgiving.com) is the UK’s largest online fundraising platform and has helped 12 million people raise &#163;700 million for more than 9,000 charities since 2001. In 2009, JustGiving’s CEO Zarine Kharas was awarded the RSA’s Albert Medal for “democratising fundraising and technology for charities” and JustGiving was awarded the &quot;best use of technology award&quot; at the Sunday Times Tech Track 100 Awards.")
 * [DevExpress](http://www.devexpress.com/ "Save time and money with high quality pre-built components for ASP.NET, WinForms, WPF, Silverlight and VCL as well as IDE Productivity Tools and Business Application Frameworks, all backed by world-class service and support. Our technologies help you build your best, see complex software with greater clarity, increase your productivity and create stunning applications for Windows and the Web in the shortest possible time. Learn more at www.devexpress.com.")
 * [CounterSoft](http://www.countersoft.com "Since 2003 Countersoft has been about enabling the collective capability that exists within all teams and projects")
 * **[JetBrains](http://www.jetbrains.com "JetBrains :: World&#39;s Leading Vendor of Professional Development Tools")**
 * [Telerik](http://www.telerik.com "Telerik is a market-leading provider of UI controls and components for ASP.NET AJAX, ASP.NET MVC, Silverlight, Windows Phone (WP7), WPF and Windows Forms, as well data access layers, reporting, code analysis and refactoring tools across all major Microsoft development platforms. Combined with its automated software testing and agile project management tools as well as its content management system, Telerik offers an end-to-end solution for building applications with unparalleled richness, responsiveness and interactivity. Telerik products help thousands of companies be more productive and deliver reliable products under budget and on time.")
 * [Quest](http://www.quest.com/ "Quest Software (Nasdaq: QSFT) simplifies and reduces the cost of managing IT for more than 100,000 customers worldwide. Our innovative solutions make solving the toughest IT management problems easier, enabling customers to save time and money across physical, virtual and cloud environments.  For more information about Quest solutions for application management, database management, Windows management, virtualization management, and IT management, go to www.quest.com. ")
 * [ThoughtWorks](http://www.thoughtworks.com "ThoughtWorks, Inc. is a global IT consultancy providing Agile-based systems development, consulting, and transformation services to Global 1000 companies. It has pioneered many of the most advanced and successful Agile methods of software development and best practices used in the industry today. At its core, ThoughtWorks helps its clients maximize investment and performance across a portfolio of complex, business-critical applications, while reducing time and risk. Its products division, ThoughtWorks Studios, offers tools to manage the entire Agile development lifecycle through its Adaptive ALM solution™, comprised of Mingle&#174;, Go&#174; and Twist&#174;. ThoughtWorks employs 1,700 professionals to serve clients from offices in Australia, Brazil, Canada, China, Germany, India, the United Kingdom and the United States. For more information, please visit www.thoughtworks.com.")
 * [Kentico](http://www.kentico.com "Kentico CMS is a versatile, extensible platform that enables you to deliver the latest Web technology to customers of all sizes. Content-oriented sites, community sites, online stores and intranets—Kentico can do it all. Use Visual Studio and your .NET Framework skills to accelerate the development process. Add out-of-the-box modules that will wow your customers with advanced functionality. Customize and integrate the site with other systems using fully documented open APIs. And enjoy a streamlined deployment experience that is second-to-none. Kentico is designed to maximize your productivity, so you can work smarter not harder. If you are looking for a Web development platform that delivers immediate results while supporting long-term business growth, try Kentico CMS.")

### Contributors ###

I've marked links in bold where I or my team used a product or service from that contributor over the course of the weekend. An extra-special thanks to them!

 * [PostSharp](http://www.sharpcrafters.com/)
 * **[LeanKitKanban](http://www.leankitkanban.com/)**
 * [InformIT](http://www.informit.com/index.aspx)
 * [AppHarbor](http://www.appharbor.com)
 * [Pusher](http://www.pusher.com/)
 * [PluralSight](http://www.pluralsight-training.net/microsoft/)
 * [LogicNP](http://www.ssware.com/)
 * **[HasBean](http://www.hasbean.co.uk)**
 * **[TeaPigs](http://www.teapigs.co.uk)**
 * [SqlSentry](http://www.sqlsentry.com/)
 * [TX Text Control](http://www.textcontrol.com/)
 * [O'Reilly](http://www.oreilly.com/)
 * **[Dominos Pizza](http://www.dominos.co.uk/)**
 * [TypeMock](http://www.typemock.com)
 * [DiscountASP](http://discountasp.net/)
 * [SaaS Made Easy](http://www.saasmadeeasy.com)
 * [BeanStalk](http://beanstalkapp.com/)
 * [Heroku](http://www.heroku.com)
 * [SyncFusion](http://www.syncfusion.com/)

### People ###

A **MASSIVE** thank you to <a href="http://www.paulstack.co.uk/">Paul Stack</a> and <a href="http://www.twitter.com/rachelhawley">Rachel Hawley</a> for being mad enough to run this event, and all their efforts organising GiveCampUK; it is a truly phenomenal achievement.  

Huge thanks also to the GiveCampUK assistants, <a href="http://www.twitter.com/plip">Phil Winstanley</a>, <a href="http://www.twitter.com/apwestgarth">Andy Westgarth</a>, <a href="http://www.twitter.com/davesussman">Dave Sussman</a> and <a href="http://www.twitter.com/lethrir">Kim Richmond</a> for their efforts in ensuring everything ran smoothly, resolving problems.

UCL's loan of their building for the weekend was hugely appreciated, in spite of the various wireless connection issues.  As Paul mentioned, no other venues were willing to offer us a space for free, which UCL very kindly did.  Fabulous generosity from them.  

Most of all, a big thank you to the GiveCRM team for being such a great bunch of people to work with!

<a href="http://www.flickr.com/photos/bertcraven/6273304619/in/photostream" title="The GiveCRM team, on Bert Craven's Flickr Stream"><img src="http://farm7.static.flickr.com/6105/6273828732_f67b4b3ce4_z.jpg" alt="The GiveCRM team" title="The GiveCRM team" /></a><br />
<span style="font-size: small">L-R: <a href="http://www.twitter.com/anthonysteele">Anthony Steele</a>, <a href="http://www.twitter.com/lethrir">Kim Richmond</a>, <a href="http://www.twitter.com/chrisjdiver">Chris Diver</a>, <a href="http://www.twitter.com/saqibs">Saqib Shaikh</a>, <a href="http://www.twitter.com/robinem">Robin Minto</a>, <a href="http://www.twitter.com/kendallmiller">Kendall Miller</a>, <a href="http://www.twitter.com/adrianbanks">Adrian Banks</a>, <a href="http://www.twitter.com/alastairs">me (Alastair Smith)</a>, <a href="http://www.twitter.com/johanbarnard">Johan Barnard</a>, <a href="http://www.twitter.com/markrendle">Mark Rendle</a>, <a href="http://www.twitter.com/nbarnwell">Neil Barnwell</a>, <a href="http://www.twitter.com/nathangloyn">Nathan Gloyn</a>.  Photo copyright &copy; <a href="http://www.flickr.com/photos/bertcraven/">Bert Craven</a> 2011. Used with permission.</span>

Conclusion
----------

This was the first ever GiveCampUK, and a number of people I have spoken to about it in the last few months since it was announced indicated an interest but a reluctance to take part, borne I think out of not knowing what the experience would be like.  I started this blog post by saying that GiveCamp UK was one of the greatest experiences of my life, and **I stand by that statement wholeheartedly.**  I hope that, with the inaugural event behind us, those people interested in it this time around but that didn't sign up will have a better idea of what to expect and might be more willing to sign up next time.  From the excellent organisation of the event, to the chance to work with some top developers and interesting technology, to the massive sense of achievement and the pride in the work completed, this was utterly unique and electrifying and inspirational.  

**See you at GiveCampUK 2012.**

Bootnote
-------

[GiveCRM](http://www.givecrm.org.uk/) is under active continued development. You can [fork us on GitHub](http://www.github.com/GiveCampUK/GiveCRM), follow us on Twitter ([@GiveCRM](http://www.twitter.com/givecrm), and ["Like" us on Facebook](http://www.facebook.com/givecrm).  We're in the process of putting together a coherent plan to take the project forward in a more structured way; keep an eye on the Twitter account for details!
