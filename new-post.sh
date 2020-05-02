#!/bin/sh
DATE=`date +%s`
EDITOR=${EDITOR:-`which vim`}
title=${1:-`read -p "What is the title of the blog post? " title; echo $title`}
file=_posts/$(date -j -f "%s" $DATE +"%Y-%m-%d")-${title// /-}\.md
cat <<POST > $file 
---
title: $title
created: $DATE
---
POST

$EDITOR $file

