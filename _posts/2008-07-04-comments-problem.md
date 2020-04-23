---
layout: post
title: Comments Problem
author: alastairs
nid: 9
created: 1215204861
---
So it seems there's currently a problem with the comments' system.  First of all, <a href="http://en.wikipedia.org/wiki/DON%27T_PANIC!" title="Wikipedia Article on The Hitchhiker's Guide to the Galaxy">DON'T PANIC!</a>  Your awesome comments are being posted correctly, and are making it through to the moderation queue fine (or being posted if you've got an account).
<!--break-->
The bad news is the Akismet anti-spam module I've installed is in beta for Drupal 6 at the moment, and an error in the module is causing the screen to go blank when you hit "Save" to publish your awesome comment.  

If you want the technical detail, a function that this module called has been removed from the Drupal API in Drupal 6.  There's more information available on the <a href="http://drupal.org/node/240894" title="Call to undefined function drupal_submit_form in Drupal 6 when user submits a comment">bug report</a> over at <a href="http://drupal.org">Drupal.org</a>.
