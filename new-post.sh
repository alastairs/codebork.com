#!/bin/sh
DATE=`date +%s`
EDITOR=${EDITOR:-`which vim`}
title=${1:-`read -p "What is the title of the blog post? " title; echo $title`}
category=${2:-`read -p "What category should the post be filed under? " category; echo $category`}
file=_posts/$(date -j -f "%s" $DATE +"%Y-%m-%d")-${title// /-}\.md
cat <<POST > $file
---
title: $title
author: Alastair Smith
category: $category
created: $DATE
tags:
 -
---
POST

git fetch --prune
git checkout -b "draft/${title// /-}" origin/master
git add -A "$file"
git commit -m "Created new post"

$EDITOR $file

