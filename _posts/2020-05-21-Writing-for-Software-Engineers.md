---
title: Writing for Software Engineers
author: Alastair Smith
category: meta
created: 1590095003
tags:
        - writing
        - meta
        - toolchains
        - git
        - prettier
        - overcommit
        - jekyll
        - GitHub Pages
        - automation
---

# Writing for Software Engineers

Well, tonight's been fun. Sat out in the garden, putting together my toolchain
for blogging. Ever since I first used Vue.js in 2018, I've been really impressed
with the ecosystem, and the automated tooling provided by vue-cli, especially
around things like integration with Prettier and Husky (well, Yorkie) to ensure
everything is written just so. No arguments over code styles, no cognitive load
from parsing inconsistently-formatted codebases, just [go](https://golang.org/)
code. The slickness of that experience was something I wanted to replicated for
my blog, so I didn't have to worry about, e.g., line lengths, Markdown errors,
etc. So, herein lies the tale of my sweet authoring setup.<!--break-->

## new-post.sh

This is where it all started: a few nights ago, writing [a little Bash
script](https://github.com/alastairs/codebork.com/blob/master/new-post.sh) to
scaffold a new [Jekyll](https://jekyllrb.com/) post. I really like the
combination of Jekyll and GitHub pages for the Markdown file-centric editing
experience, the zero-cost hosting, and the Continuous Deployment from the chosen
Pages branch. The only thing missing from the out-of-the-box experience, as far
as I've found at least, is an easy way to create a new post, and this is the gap
I decided to fill.

The script is pretty short: much of the code you see below is the template blog
post, and even that could probably be factored out into a separate file rather
than a here document.

```bash
#!/bin/sh
DATE=`date +%s`
EDITOR=${EDITOR:-`which vim`}
title=${1:-`read -p "What is the title of the blog post? " title; echo $title`}
category=${2:-`read -p "What category should the post be filed under? "category; echo $category`}
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

$EDITOR $file
```

The script prompts (via variable substitution) for a title and a category, or it
will read them from arguments passed to the script, like `./new-post.sh 'My new
blog post' meta. It stashes the current date and time as a number of seconds,
which can then be reformatted for use in the filename, and interpolated into
the`created` field in the YAML front matter of the post template.

As I'm on a Mac, I found the date munging quite tricky in comparison with my
expectations. It turns out, BSD ships an extended version of the standard UNIX
`date` command, with ~subtly~ wildly different behaviour.
