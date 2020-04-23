---
layout: post
title: PHP Web Deployment Using Git
author: alastairs
nid: 145
created: 1275610060
---
I've recently been working on a new version of my personal website, which can be found over at http://www.alastairsmith.me.uk/.  I wanted a light-weight site that would pull in data from my various presences across the web including my two blogs, GitHub, and Google Picasa; furthermore, as much as possible should be hosted on some form of Content-Distribution Network (CDN).  Google's CDN is serving up jQuery and jQuery UI quite nicely for me whilst minimising the amount of stuff I need to administer and maintain myself.  

It's generally a good idea when developing web applications to keep your in-development version separate from your production version; indeed this goes for many development scenarios, including in-house application testing before rolling out to users, desktop software development, and others.  The backbone of such a strategy is a good source control system, and whilst centralised source control like Subversion can handle this capably, a certain amount of friction is involved in setting it up.  Distributed version control systems, and Git in particular, can remove this friction.

Because my personal website is so small by design, the friction of setting up a centralised source control system for deployment scenarios for such a tiny application would have been great enough to put me off looking into it any further.  Luckily, I switched to Git as my version control tool of choice about a year ago, and haven't really looked back.  Here's how I accomplished a simple web deployment mechanism that can work for sites with a back-end component as well as a smart front-end.
<!--break-->
After a bit of Googling, I came across <a href="http://stackoverflow.com/questions/279169/deploy-php-using-git/327315#327315" title="Deploy PHP using Git">this Stack Overflow answer</a> which accomplishes everything I need in a very simple and frictionless manner.  It requires minimal set-up, and, once complete, deployment is as simple as running <code>git push production</code>.  <strong>How neat is that?</strong>

In essence, the solution is to check out your web application from your Git repository to your production web server, create a post-update hook that will update the web server's working copy after a push operation, and create a new remote configuration entry in your development copy.  You can then hack away in your dev copy, run all the necessary tests, and push it up to the production server when you're satisfied with it.  The post-update hook is the trickiest bit of the process, and even that has been completed for you and is available <a href="https://git.wiki.kernel.org/index.php/GitFaq#Why_won.27t_I_see_changes_in_the_remote_repo_after_.22git_push.22.3F" title="Git post-update hook script to update a working copy after a push">from the Git wiki</a>.

There is a further step alluded to in the comments on that answer, which is to ensure you lock down your .git directory on your production web server.  Exposing that directory and its contents can provide the entire source code for your application, which is likely not what you want, particularly from a security perspective.  I'd forgotten most of my Apache-configuration-fu so it took me a while to work out the correct .htaccess directives, but it would appear to be relatively simple: create an .htaccess file <strong>in your .git directory</strong> and enter the following code:

<blockcode>
deny from all
</blockcode>

You will also likely want to add the following code to an .htaccess <strong>in your application's root directory</strong> (i.e., the parent of the .git directory):

<blockcode>
Options -Indexes
</blockcode>

Similar access controls will need to be set in other web servers such as IIS; non-Apache configuration is left as an exercise for the reader.

The only down-side to this solution (which, realistically, is unavoidable) is that the new remote configuration needs to be specified on each working-copy you wish to develop in, but that is a quick and easy thing to define.  It may also cause you to forget to push to your origin repository regularly, as you push to production instead, but this isn't anything a little discipline can't solve.
