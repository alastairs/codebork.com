---
layout: post
title: 'Git: Rescuing changes that have been merged over'
author: alastairs
nid: 181
created: 1320701931
---
So we ran into a little bit of bother with some pull requests to [GiveCRM](http://www.givecrm.org.uk/): I had submitted a feature that had been merged in, but it was subsequently lost (in part) when a later pull request was merged in.  It seems the submitter of the later pull request hadn't updated from the central repository before submitting his pull request, so when his pull request was merged my feature was overwritten.  

My experience with Git is almost entirely as an individual developer, so I'm learning how to use it in a distributed team as we go with GiveCRM.  I turned to my friend, colleague and resident Git expert [Adam Wood](http://www.twitter.com/adamwood80) for some advice.

<!--break-->

This is what the graph of commits looked like

                 o----------------o----------
                /                            \
    -----+--+--+-------+------------------+-+-+----
                        \                  /
                         x-------x--x-x-x--

The `+`s are master; the `x`s are my feature's branch, and the `o`s are the other branch.  

I wondered initially if it might be resolvable by taking a branch at the point at which I finished my feature and rebasing that on master, but this didn't work, as might be expected.  We tried a few other things, like revert and reset --soft, but eventually we worked out we could do the following, which was rather simpler.  The following commands are what I did; there's probably a quicker/easier way to do some of them.

    git checkout 12345abc

This puts you in "detached HEAD" mode at the given commit. This basically means, as far as I can tell, that the repository contents are at the specified commit, but you can't make any changes to the repository and expect to keep them: git's internal reference tracking is sort of "turned off".  (Hopefully someone can explain that better than me!)

    git checkout -b FeatureRescue

This creates a branch from the current detached HEAD state of the repository.  There's probably a `git branch FeatureRescue 12345abc` that I could have done instead, but whatever.

    git checkout -b integration

Create an integration branch to mess around in - you don't want to lose the branch you've created where the feature is still intact!

    git merge abcdef123

Merge the commit(s) that overwrote the feature.  I was lucky that the pull request only contained one commit.

    git mergetool

Fix up the merge conflicts that should have arisen when the pull request was merged in...

    git commit -m "Re-apply [x] change"

Commit the merge to the integration branch.  

    git checkout master
    git merge integration

Switch back to master, and merge in the integration branch.  Sorted!

Not *quite*.  I ran into the unfortunate situation where there was another file that was correctly updated in the integration branch, but didn't get merged into master at the end.  This, I think, was because the file was not changed on master after my initial pull request.  I had to apply this change manually, but that was thankfully trivial.  

If you know a simpler way to accomplish this, please leave me a comment!
