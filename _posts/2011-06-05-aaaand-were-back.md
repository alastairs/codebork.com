---
layout: post
title: "...aaaand we're back."
author: alastairs
nid: 157
created: 1307277450
---
Well, you might have noticed a change of look around here. Over the weekend, I upgraded this blog to Drupal 7, which was released a couple of months ago.  

<!--break-->

It seems that sometime in the last year Drupal also made the move to Git.  This, I hope, will vastly improve the update and third-party add on story; indeed, I am trying out the following plan:

  1. Check out the latest Drupal source (7.x branch) from http://git.drupal.org/project/drupal.git ([Drupal-specific instructions](http://drupal.org/node/3060/git-instructions/7.x)).  
  2. Check out each module as a Git submodule.  E.g., for the Views module, the appropriate incantation would be (from your Drupal installation directory) `git submodule add http://git.drupal.org/project/views.git sites/all/modules/views -b 7.x-1.x`.

I think this should allow me to keep my Drupal installation up-to-date automatically just by running `git pull` and `git submodule update` every so often.  I won't be able to verify this until a module or Drupal core update is released, though.  

Drupal 7's emphasis on improving usability over new features has yielded good results.  It's much easier to find the things I'm looking for in the admin interface; there's a new shortcut menu that sits at the top of the page, and the admin tasks overlay the site itself.  Some sections have been collapsed into a single tabbed section.  

The theme I was using for my blog previously ([AD The Morning After](http://drupal.org/project/ad_the-morning-after)) hasn't yet been ported to Drupal 7, so for the moment I'm running the new default theme Bartik.  I've been playing around with the [Omega](http://drupal.org/project/omega) theme as well, which provides a base for building HTML5 and CSS3 themes.  There are a couple of themes built on top of Omega (notably [Beta](http://drupal.org/project/beta) and [Gamma](http://drupal.org/project/gamma))

I've also installed the [Markdown](http://daringfireball.net/projects/markdown/) [module](http://drupal.org/project/markdown) because I was fed up with editing HTML manually.  I've set this as the default input format, so you can take advantage of this when leaving comments too.  
