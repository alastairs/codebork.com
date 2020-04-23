---
layout: post
title: 'Fun with Typescript and CasperJS'
author: alastairs
created: 1494081968
excerpt: "I've spent the last couple of days writing smoke tests for our application with [Typescript](https://typescriptlang.org/) and [CasperJS](http://casperjs.org/), and hit quite a bit of pain along the way, so I thought I'd share what I'd learned."
---
I've spent the last couple of days writing smoke tests for our application with [Typescript](https://typescriptlang.org/) and [CasperJS](http://casperjs.org/), and hit quite a bit of pain along the way, so I thought I'd share what I'd learned.

CasperJS is a “navigation scripting and testing tool” that automates PhantomJS and SlimerJS, semi-headless implementations of Chrome and Firefox respectively. (Side note: If you can use ES7, take a look at ghostjs, which supports the new async/await syntax.)

The first thing was getting the development environment set up. I'd not done this for Typescript for a couple of years and a lot has changed in that time, so I decided to go from first principles. Most of the available tutorials say to install the tools globally with `npm install -g`, but I wanted to avoid having to install more things to our build agents. Here's what I went with:

    npm install --save-dev typescript@2.3.2
    npm install --save-dev typings@2.1.1
    npm install --save-dev casperjs@1.1.3
    npm install --save-dev phantomjs-prebuilt@2.1.14

If you've not come across it, Typings is a neat command-line tool for managing Typescript definitions. It can source typings from a range of places, including DefinitelyTyped and npm. The next step was to install the typings for Casper and Phantom:

    touch tsconfig.json
    typings install dt~casperjs
    typings install dt~phantomjs

This will set up typings in `pwd` so be sure you run this from the desired root of your Typescript project (this is where `tsconfig.json` lives). You'll also need the full path to your `node_modules\.bin` on your PATH. (The `dt~` prefix instructs Typings to obtain the type definitions from DefinitelyTyped as it defaults to npm.) You'll now have a `typings` directory containing the type definitions and a `typings.json` file listing the installed typings. Note that Typings has modified the `tsconfig.json` to reference `typings/index.d.ts`: Typings controls this file to pull together all the type definitions it installs into a single place that can be easily referenced. _(Side note: each imported type definition specifies its own `index.d.ts` which is pulled into Typing's `index.d.ts` with a series of `/// <reference />` statements. Neato.)_

I also needed to configure my editor. VS Code is a great editor, and it comes with bundled support for Typescript, so it was a no-brainer to use this. The first thing I noticed was that it uses its bundled Typescript compiler, which was currently at version 2.2.2, but I had installed 2.3.2 (yesterday's VS Code update bundles 2.3.2). Luckily, there's [great documentation on how to achieve this](https://code.visualstudio.com/docs/languages/typescript#_using-newer-typescript-versions) (TL;DR: set `typescript.tsdk` in your workspace settings to the appropriate path). There's also a great [tutorial on the VS Code site](https://code.visualstudio.com/docs/languages/typescript) which details how to set up VS Code for a nicer editing experience, including hooking up the Typescript compiler to the `Ctrl+Shift+B` task runner command. I use a slightly different set of arguments to `tsc` to add compile-on-save support, so my `tasks.json` looks like this:

    {
        // See https://go.microsoft.com/fwlink/?LinkId=733558
        // for the documentation about the tasks.json format
        "version": "0.1.0",
        "command": "tsc",
        "isShellCommand": true,
        "args": ["-w", "-p", "test/smoketests"],
        "showOutput": "silent",
        "isBackground": true,
        "problemMatcher": "$tsc-watch"
    }

Great, we're finally ready to go!

---

I started writing my Casper tests, following [this excellent post](http://jsebfranck.blogspot.co.uk/2014/03/page-object-pattern-with-casperjs.html) on using the Page Object pattern with Casper. It was here that I hit my first issue: when running the tests, PhantomJS would complain that the `exports` variable could not be found. After a lot of fruitless searching through Stack Overflow and GitHub, I found that Typescript was outputting a line in my page object akin to `Object.defineProperty(exports, /*..*/)` and this was what was causing Phantom to baulk. I resolved this by down-grading to Typescript 2.1.4 instead, as this version was known to work from a previous project. Annoyingly, and as with a lot of the problems I've hit with Typescript and co. this week, I'm no longer able to reproduce the problem.

Another issue was in calling Casper's `evaluate()` function. This can be a little tricky to understand as it passes a closure to PhantomJS to execute in the context of the current page's DOM. It's particularly useful in conjunction with the waitFor() function. I was using it to query a CSS selector (before I found the handy `waitForSelector()` function!), where the selector was an instance member of my page object. Something like this (line 18 is the key):

<script src="https://gist.github.com/alastairs/6c3b1ce626d5bbeee6f0757be1a36a4c.js"></script>

The more well-versed in Typescript and JavaScript will probably have identified that the closure can't access the instance variable of the class, as (I _think_) `this` doesn't refer to the class instance anymore, but (I _think_) the calling context of the lambda function. Pulling it out as a globally-defined constant works, of course, as does passing it as a parameter to the closure supplied in `evaluate()`. Of course the whole thing can be collapsed to the much more simple

    this.casper.waitForSelector(this.OAUTH_AUTHORISATION_FORM)

so I'm only including this for posterity 😀

Now that these issues have been worked through, the stack is working quite nicely for me. There are some on-going problems with console output being dumped after `casperjs test` exits), but I suspect these are specific to the Windows console host. Bash on Ubuntu on Windows 10 works a little better — the console control sequences are more well-understood in this environment — but it seems as though the details of test output (including the PASS/FAIL status of each test) is lost somewhere. Hopefully these issues will be resolved in time.
