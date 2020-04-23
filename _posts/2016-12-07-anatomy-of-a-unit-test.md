---
layout: post
title: 'The Anatomy of a Unit Test'
author: alastairs
created: 1481119718
permalink: /2016/12/07/anatomy-of-a-unit-test.html
---
> This is the latest in a series of posts I'm writing to support a new online course I'm putting together for [Decacoder](https://www.decacoder.com/) called _Testing your code like a pro_. [Follow me on Twitter](https://twitter.com/alastairs) for updates on the course. 

I've been practising and honing my unit testing techniques for around ten years now, and one of the key realisations I hit upon a while ago is that tests are like a sort of mini science experiment. They have a stated hypothesis, and that hypothesis is either proved or disproved depending on whether the test passes or fails respectively. I've noticed that good tests follow a structure very similar to that of a simple science experiment, such as those practised in school. Let's explore this in some more detail.

## The Scientific Method

[Wikipedia introduces the Scientific Method](https://en.wikipedia.org/wiki/Scientific_method) as "…a body of techniques for investigating phenomena, acquiring new knowledge, or correcting and integrating previous knowledge." It can be thought of as a process for exploring a specific knowledge space, identifying the (current) boundaries and limits of that space, which landmarks signpost new areas, etc. We explore a knowledge space with _experiments_, the purpose of which is to "determine whether observations agree with or conflict with the predictions derived from a hypothesis".

The Scientific Method suggests the following general structure for an experiment:

1. **Hypothesis**: the idea or theory we wish to prove or disprove
2. **Method**: a detailed description of how we intend to go about proving or disproving our hypothesis
3. **Observations**: the raw results obtained by following the method
4. **Analysis**: an inspection of the observations to determine their significance
5. **Evaluation**: based on the analysis, a conclusion on whether we can prove/disprove our hypothesis

Let's say for example we wish to see if bricks float in water. We might design our experiment as follows.

> # Hypothesis
> Bricks float in water
> # Method
> ## Equipment
> 1. [Standard ten-litre bucket](http://www.diy.com/departments/curver-silver-plastic-10-l-bucket/196609_BQ.prd), measuring 305mm in diameter and 315mm high
> 2. [Standard clay house brick](http://www.diy.com/departments/wienerberger-brick-red-clay-facing-brick-h1025mm-w65mm-l215mm-2206kg/54157_BQ.prd?SRD_bricks) measuring 215mm long by 65mm wide x 102.5mm high, weighing 2.206kg
> ## Process
> 1. Fill the bucket to 90% capacity with 9 litres of water
> 2. Place the brick on the surface of the water
> 3. Let go of the brick
> 4. Complete steps 2. and 3. above for a total of 100 trials
> # Observations
> | Trial | Brick Floated |
> |-------|---------------|
> | 1     | No            |
> | 2     | No            |
> | 3     | No            |
> | …     | …             |
> | 98    | No            |
> | 99    | No            |
> | 100   | No            |
> # Analysis
> 100% of trials resulted in the brick floating. The mean, median and mode number of times the brick floated was 0, with a variance of 0. In trial 37, it appeared that the brick was floating, but it turned out the brick had not been fully released into the water.
> # Evaluation
> The results are conclusive: that brick did not float in the water. We can be more confident in the general case by:
>
> 1. Trying other bricks
> 2. Trying different water
>
> Other factors which may be important include the temperature of the water, the liquid itself, and the material from which the brick is made.

There are three important consequences of the Scientific Method, namely that the experiments are reproducible, falsifiable, and provide a measure of confidence in the results.

### Reproducible
Given the very detailed description of the necessary equipment and the process of collecting results included in step 2, other scientists are able to replicate our experiment independently. This is important for verification of the results: if others follow our process and replicate our results, then the _confidence_ in those results is increased. Furthermore, attempts to reproduce the experiment can identify flaws in its design, improvements that can be made to increase confidence in the results, or areas for further areas of investigation. 

### Falsifiable
Not only does the documentation of the experiment allow others to replicate the experiment, it also offers the opportunity to _falsify_ the results, i.e. to refute them or prove them incorrect. Falsification is an important concept: the experiment must be constructed in such a way as to _allow_ for the hypothesis to be proven false. Furthermore, because the experiment is reproducible we allow the _opportunity_ for falsification. 

### Confidence
Overall, the results of the experiment are expressed with a degree of confidence. This is usually expressed in a number of standard deviations from the mean, or n-sigma. For example, particle physicists use 5-sigma as their degree of confidence, meaning that if our brick floated because of chance and the experiment was repeated 3.5 million times, then we would expect to see the brick to float precisely once in all of those trials. 

## Structure of a unit test

The following pseudocode describes the most common testing structure:

    a_descriptive_test_name_of_our_expected_behaviour()
        var dependency = new Dependency();
        var system_under_test = new SystemUnderTest();

        var result = system_under_test.action();

        var expected = "expected result"
        assertThat(result, equals(expected));

You may already be familiar with this structure, known as the [Arrange-Act-Assert](http://wiki.c2.com/?ArrangeActAssert) pattern.*

Revisiting this pseudocode sample in light of the Scientific Method, we can see that this pattern closely matches the one described there. Our test name is our hypothesis: we are stating something about the system which the test will prove correct or false. 

The test function itself is the method. In the Arrange phase, we describe the equipment we need, set it up appropriately, and prepare the _system under test_ for the experiment. The Act phase is actually carrying out the experiment for one trial, and the Assert phase is recording the result of that trial. Build servers can give us an insight into our tests' success and failure rates, providing a level of analysis, from which we can evaluate the data to draw our conclusions about the system under test (or perhaps the quality of those tests). 

Beyond the parallels with the Scientific Method, this structure provides us with a number of additional benefits. Following this structure as a convention allows us to more quickly understand a suite of tests we haven't previously (or even recently) encountered. Furthermore, the implication of isolating tests from one another is similar to the concept of avoiding contamination in science experiments. 

## Test Names

> There are two hard things in Computer Science:  cache invalidation, and naming things.
> -- [Phil Karlton](http://martinfowler.com/bliki/TwoHardThings.html)

If our test names are our hypotheses, then suddenly it's clearer why names like `test1`, `doesItWork`, `test_my_object`, `test_bank_transfer`, etc. are unhelpful: they simply tell us nothing about the system under test, the context in which its operating, or, well, _anything_. A _good_ test name, on the other hand, is highly specific; for example `withdrawing_an_amount_from_an_account_should_decrease_the_accounts_balance_by_that_amount`. Note also that important word `should` in there: this sets the tone for the entire test name; without it, or some equivalent word such as "must" or "will", we cannot adequately describe the sentence as a hypothesis. 

## Test Size
Tests are best kept small and focussed. Rigorously applying the Single Responsibility Principle to your tests — i.e., that test functions should only test one hypothesis — keeps our tests small and focussed. Scientific experiments don't try to (in)validate more than one hypothesis at a time, and neither should our unit tests. A maximum of 10—15 lines per test function is best; more than this and the amount of work the test does becomes difficult to reason about. 

A helpful rule of thumb for measuring how many things are being tested is the number of assertions that the test contains. If it contains a single assertion, then you can be certain it is testing only one thing; however, multiple assertions can still be ok if they form a single _semantic_ or _logical_ assertion. For example, for a system transferring an amount of money from one bank account to another, you may wish to write two assertions to prove that both accounts are updated correctly. 

## Independence
Finally, it is important that both tests and test _runs_ are independent of each other: one test should not interfere with another, and running the same test multiple times over an unchanged piece of code should always produce the same result. Tests that influence each others' results are equivalent to contamination in a science lab: they result in anomalous observations, or results that are just plain wrong. 

Just as contamination is usually the result of the influence of some external system (e.g., being exposed to the air), so it goes with unit tests. The network, file system, and database are all obvious contaminating systems; dates/times and random number generators are less-obvious contaminating systems that are no less problematic. It is important to introduce sensible abstractions for your application to ensure that your unit tests execute in a cleanroom environment free from external influence and the information we glean from our tests is not affected by things we cannot control.

## Conclusion
We've looked at the Scientific Method, and an example science experiment based on this method, drawing out the key repercussions of the method of reproducibility, falsifiability and confidence. We've drawn parallels between the structure of a simple science experiment and the Arrange-Act-Assert pattern recommended for unit tests. We talked about the Scientific Method as an act of exploration in a knowledge space, and we can view writing unit tests, particularly in a test-first style, in a very similar way.

In the next post in this series, we'll be looking into the different types of test doubles. 

--

\* The [Given-When-Then](http://martinfowler.com/bliki/GivenWhenThen.html) convention favoured by implementations of Gherkin, such as Ruby's Cucumber and .NET's SpecFlow, maps directly to these three steps.

