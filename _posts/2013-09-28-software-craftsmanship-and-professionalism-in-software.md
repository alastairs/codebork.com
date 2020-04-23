---
layout: post
title: Software Craftsmanship, and Professionalism in Software
author: alastairs
nid: 230
created: 1380365002
---
Another thing to come out of my reflections on Software Craftsmanship at SoCraTes UK this weekend was a clearer view on what professionalism means to me for software craftsmen. I believe there are three pillars of professionalism that need to be considered:

* A mindset of taking a methodical, deliberate, and considered approach to your work;
* Leaning on your tools, but not being dependent upon them; and
* Taking personal responsibility for your decisions and actions

<!--break-->

## The First Pillar: Mindset

The first pillar, that of the approach one takes to their work, is what allows us to deliver quality software. It is also, perhaps, one of the things we would like to be judged on when sharing our work with others. It is about being careful (not, in this context, in the "cautious" sense of the word) in our implementations to ensure that what we deliver meets our standards. Let's delve into each of the words I used a bit further.

### Methodical

A methodical approach is one that is systematic and orderly. For example, the Test-Driven Development process takes the form of three steps that are repeated in a loop: red, green, refactor; red, green, refactor; red, green, refactor; etc. This process is both systematic - it encompasses a system that is defined as "implement software incrementally, by writing your tests first, making the tests pass, and making incremental improvements to the tests and implementation" - and ordered, in that the steps have to be completed in the order listed: you can't refactor code when you have failing tests, and if you end up with failing tests after making another test pass (or during a refactoring), you have broken something.

It goes further than this, however: for example, seeing the test fail *for the right reason*. That is, if your test passes because your code already covers the case you're now testing, you go back and change your implementation code to make that new test fail. If you see the test fail because of a compilation error, or because of an exception thrown, you go back and make sure the assertion itself fails when the behaviour it is testing fails.

### Deliberate

A deliberate approach is one where each of the steps are there for a reason, they have a specific intent. Taking again the Test-Driven Development process of red-green-refactor as our example, we can see that each of the steps in the process have a purpose, and in the order described. By writing our test first, we commit to a small unit of behaviour that we specify with the test. In the green phase, we implement the behaviour specified. Finally, in the refactor stage, we incrementally improve the design of our code to remove duplication and other smells. 

Again, this also ties back to seeing the test fail for the right reason. Each of the three steps are there for a purpose, so we don't skip over any of them even when it looks like we've met the high-level goal of making bar go green or red; we dig into it further to ensure that we've achieved that goal for the right reason, that the purpose of the current step has been satisfied.

### Considered

A considered approach is one that you have thought about, one that you can defend for your own reasons when challenged on it. You have made the decisions you have, and taken the approach that you have, as the result of thinking about what it is you are doing; not simply following orders, or naively following a process, or being a passive participant in your team's activities.

When I first picked up TDD, I did so without contemplating in much detail the approach it defines. As a result, when I came to introduce the concept to my team at work, I had some tough questions to answer from them about the value of the approach and the detail of the process that I wasn't able to satisfactorily address in some cases. 

### The Mindset: Mindfulness

Mindfulness is perhaps most easily understood as the very opposite of mindlessness, a word many more people are familiar with: we can all picture a person working as an automaton, completing a task they've done hundreds or thousands of times before, doing it without thinking, without engaging with the task at all. We've all had the experience of making a journey somewhere, perhaps on foot, by bike, or in a car, and arriving at our destination without much recollection of the journey there. Mindfulness is about engaging with the task you're undertaking, being an active participant. 

Taking a methodical, deliberate and considered approach to your work instills a mindset of mindfulness in your work, which I believe is important to mastering your craft. Being mindful of your work provides you with greater opportunities for learning from your mistakes, the situations you encounter at work, and the context around you. It means challenging your practices and principles, and accepting that they will be challenged by others. It means thinking about what you are doing and justifying your approach to yourself.

You might be reading this and thinking that what I'm suggesting sounds like perpetual self-doubt; this is not the case. Self-doubt comes at this process from a negative position, where you're questioning your motives and decisions for the simple reason that you made them. Mindfulness comes from a much more positive position, that of curiosity: you question your approach with the intention of learning from the decision, you're curious as to whether there is a better approach that can be taken, a more efficient practice that can be learned, etc.

## The Second Pillar: Tools

Every craftsman has his or her tools: the carpenter has saws, hammers, lathes and more; the surgeon has a scalpel, an endoscope, and sutures; the software developer has their editor or IDE, refactoring tools, test runners, version control system, and more. Tools are an important part of any craftsman's job, and knowing your tools well can be the difference between doing a good job and bad job, producing quality product over poor product, creating more product over less product, etc.

A craftsman should not be dependent upon their tools, however. Being prepared to put a tool to one side to try a new one out is just part of this: how will you know if something better is available if you never try it? For example, a large number of C# developers have a copy of ReSharper at work, and many have their own copy at home as well. This tool came about in the first place because of poor support within Visual Studio for basic refactoring operations like rename and extract method. However, there is a manual approach, described by Martin Fowler in his [original text on refactoring](http://www.amazon.co.uk/Refactoring-Improving-Design-Existing-Technology/dp/0201485672/): add-update-remove. It is a methodical, deliberate, and considered process that allows you to complete a refactoring manually without seeing a compilation error; for example, if adding a parameter to a method:

1. Add a new overload of the method that includes the new parameter, and make it call the existing overload.
2. Update all usages of the existing overload of the method to point to the new one, supplying the new argument as appropriate to that context.
3. Remove the old overload that is now unused everywhere, migrating the implementation to the new overload in the process.
4. Make the changes needed to the implementation to use the new parameter.

If you're using a modern version control system like Git, then you can commit after each of these stages as well, so you get a set of handy staging posts you can roll back to if necessary.

Here are some of the tools I consider essential for any software craftsman, no matter what language they are working in:

* **The best-available editor for your language** (defined on your own terms). Perhaps it's Visual Studio for C# developers, IntelliJ IDEA for Java Developers, vim/emacs for Ruby/Python/JavaScript developers; perhaps you prefer SharpDevelop, Eclipse, or PyCharm.
* **A plain-text editor.** Often we need to make a small change to a file, or write a commit message, or edit a supporting file. Firing up a complete IDE is overkill for this kind of scenario, so it is worth keeping around a plain-text editor for these situations, and one a little less basic than Notepad at that. I've tried a few over the last 10 or so years, and have recently come to settle on Sublime Text 2, and vim.
* **A scripting environment.** Linux users have had Bash and other shells available since the beginning of time (1 Jan 1970, as we all know). Windows now has PowerShell, and if you're a developer working in Windows regularly, you owe it to yourself to learn PowerShell well. Scripting environments put the power of automation at your finger-tips, which can be a huge time-saver. 
* **An automated refactoring tool** (if available). Some IDEs have these built in, particularly JetBrains' offerings. Visual Studio has a number of "productivity extensions" including ReSharper, CodeRush and JustCode that bring the full weight of this functionality to bear over VS' limited offering. 
* **A Distributed Version Control System**, such as Git or Mercurial. Having the ability to commit and roll-back changes locally before going anywhere near a central repository is an incredible advantage: with a bit of discipline in committing, you can mess up your working copy as much as you like and always have a recent checkpoint to revert to. Git is my weapon of choice in this arena.
* **An automated test runner, ideally with a continuous mode.** I started using [NCrunch](http://www.ncrunch.net/), a continuous test runner for Visual Studio, about 18 months ago. On projects with proper unit tests, it provides a fantastic productivity boost just having the tests running all the time in the background on each change. JavaScript developers have karma (amongst other options, I'm sure), and there are similar things available for other languages too. At work, I use ReSharper's test runner because it integrates very nicely with my IDE and our tests at work don't play nicely with NCrunch. 

Each of these tools are integral to my development process, and serve a very specific function, in exactly the same way that a lathe, a saw and sandpaper are to a carpenter's wood-working process.

## The Third Pillar: Personal Responsibility

Erik Talboom's Lightning Talk on Personal Responsibility at SoCraTes UK evidently struck a chord with everyone in the room: it was a recurring theme in sessions and conversations throughout the weekend.

Erik explained well Christopher Avery's [Responsibility Process](http://www.christopheravery.com/responsibility-process) in terms of finding and fixing a bug:

* **Denial.** First you cannot believe there is a bug. "There's no way that could happen!", you tell yourself.
* **Blame.** Next you start looking around for someone to blame for the bug. "This is Joey's code, it's his fault!", you tell yourself.
* **Justification.** Third, you look for excuses for the bug being there. "Well, if Joey hadn't used null values in his code, there would be no bug!", you tell yourself.
* **Shame.** Next, you start to lay blame yourself. "I'm such an idiot. I saw Joey working on this just last week and I didn't say anything.", you tell yourself.
* **Obligation.** Now the context and environment are at fault. "There's no way we could have done anything different, we're under such pressure to deliver on time that quality goes out the window.", you tell yourself.
* **Responsibility.** You realise there's something you can do about it. "I'll have a chat with Joey to explain why nulls should be avoided, and start trialling code reviews as part of our development process."

The alternative to responsibility, of course, is abdicating it: quitting the situation to avoid the pain associated with shame and obligation.

A key part of taking personal responsibility is mindfulness: being aware of when you are in the mental states of denial, blame, justification, etc. This awareness can help you move through the remaining stages more quickly (or skip them entirely) to reach a productive conclusion earlier.

## Conclusion
Mindfulness and Personal Responsibility are the two key "psychological" components of professionalism to me; the second pillar, Tools, provides a way of expressing those through our practices. Any amateur can use a professional's tools, but it is the approach we take to our work that indicates professionalism and denotes craftsmanship. 
