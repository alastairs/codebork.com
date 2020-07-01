---
title: Converting objects to arrays in TypeScript
author: Alastair Smith
created: 1593632109
tags:
        - typescript
        - javascript
        - pulumi
        - testing
---

Lately I've been writing TypeScript to provision Azure resources with
[Pulumi](https://pulumi.com). Pulumi's a fantastic tool, building on the proven
technology of [Terraform](https://www.terraform.io) to provide Infrastructure as
Code with _real programming languages_. Many of the samples are in TypeScript
using Pulumi's TypeScript SDK, so I opted to work with this one rather than,
say, their .NET SDK.

One of the key benefits of using Pulumi to my mind is being able to efficiently
**unit test** my infrastructure's properties, and this is something treated as a
first-class concern in [Pulumi's
docs](https://www.pulumi.com/docs/guides/testing/)—always a good thing to find!

I also opted to use this as an opportunity to learn the new AVA test runner for
JavaScript, for curiosity and learning as much anything. More detail about that
another time, perhaps. I had a set of standard properties for my Azure resources
that I wanted to test in common, similar to parameterised tests or Theories in
Xunit.net. What follows is the code I ended with sparing you, dear reader, the
hours of frustration encountered along the way. <!--break-->

## AVA Macros

AVA has a nice [Macro
feature](https://github.com/avajs/ava/blob/master/docs/01-writing-tests.md#reusing-test-logic-through-macros)
built in, which allows you to apply the same piece of test code to multiple
tests. This is what first put me on the path towards parameterising my tests in
the first place: the building blocks are right there in the framework to
encourage you to write cohesive test code minimising duplication. The example
given in the documentation is contrived but clear:

```typescript
function macro(t, input, expected) {
	t.is(eval(input), expected);
}

test("2 + 2 = 4", macro, "2 + 2", 4);
test("2 * 3 = 6", macro, "2 * 3", 6);
```

If we were to undo the macro, we'd end up with something like the following,
which has duplication all over the place:

```typescript
test("2 + 2 = 4", t => {
	t.is(eval(input), expected);
});

test("2 * 3 = 6", t => {
	t.is(eval(input), expected);
});
```

Additionally, AVA enables macros to generate the test title, so the macro
version can be made neater still:

```typescript
function macro(t, input, expected) {
	t.is(eval(input), expected);
}

macro.title = (input, expected) => `${input} = ${expected}`.trim();

test(macro, "2 + 2", 4);
test(macro, "2 * 3", 6);
test(macro, "3 * 3", 9);
```

This makes things better still, but my use case had a fixed expected value for
each test case too: could I refactor that away also?

## Azure Resources

I wanted to start out with a simple test to ensure I'd set everything up
correctly: creating a Resource Group in my Azure subscription using Pulumi. I
wanted it to be created in the North Europe (=> Dublin) region, and this seemed
like a perfect first test case: no dependencies on other resources, a primitive
property value, etc. Here's what I started with:

```typescript
// Pulumi code creating the resource group:
const groupName = conventional.nameFor(
	azure.core.ResourceGroup,
	"donabase-app"
);
export const resourceGroup = new azure.core.ResourceGroup(groupName, {
	location: "NorthEurope"
});

// Test for resource group location
import { resourceGroup } from "../index";

test("Resource group is created in North Europe", async t => {
	const [name, urn, location] = await new Promise(resolve =>
		pulumi
			.all([
				resourceGroup.id,
				resource.urn,
				resource.location
			])
			.apply(resolve)
	);
	t.deepEqual(
		location,
		"NorthEurope",
		`Resource location ${name} (${urn}) was not ${expectedLocation}`
	);
});
```

(Thanks, I guess?, Prettier, for formatting that sample so wonderfully
:unamused:)

Now, this is a general assertion I want to make about the resources in this
resource group: they should all be created in North Europe. So new resources I
add to this should also pass this test, and, ideally be automatically added to
the scope of this test as a new test case. Revelling in my success, I decided to
add my first useful resource: an Azure AppService for Linux instance, running on
the Free service tier, for development purposes. This involves three individual
resources:

- the resource group as previously created;
- an AppService Plan, defining the size of the resources backing the service,
  the charging plan, and the OS type;
- the AppService instance itself, which will run my code/container.

## Parameterising the test, the object spread operator, arrays, and much pain

I'd come across the object spread (`...`) operator numerous times before, and
felt sure that it would be possible to write syntax along the lines of [
...myObject ] to destructure it's properties into an array. I was half-right:
it's achievable, but it requires a bit of JavaScript/TypeScript wizardry. But
wait, why did I want this in the first place?

In creating the various resources mentioned above, I'd refactored my
infrastructure to an object rather than a set of `const`s. I was now able to
import into my test suite an object adhering to an `AzureAppService` interface
that contained a property for each of the three linked resources:

```typescript
export interface AppService {
	resourceGroup: azure.core.ResourceGroup;
	appServicePlan: azure.appservice.Plan;
	appService: azure.appservice.AppService;
}
```

The test I _really_ wanted to write looked like this:

```typescript
[...appService].forEach(resource => {
	test(
		`${resource.constructor.name} is created in required region`,
		inRegion,
		resource,
		"NorthEurope"
	);
});
```

Note this is **one step further than the example in the AVA docs:** I am
generating the tests as well as the test implementation. But, as I said before,
that first bit was just impossible out of the box.

Luckily the TypeScript compiler gave me a hint, although it was only
semi-coherent to me in my ignorance:

```plain
Type 'AppService' must have a '[Symbol.iterator]()' method that returns an
iterator.
```

Many places, including the TypeScript repository on GitHub, and StackOverflow
answers, are for TypeScript 2, and suggest targeting ES2015; I am using
TypeScript 3 and targeting ES2016. A _lot_ of hunting around Iterators,
Iterables, and, ultimately, Generators led me to believe I needed to define a
function called `[Symbol.iterator]` on my object, but I just could not figure
out the syntax to do this without also implementing the full iterator object,
with `next()` and more. Eventually I realised I was searching the wrong terms,
and it was a Generator I needed. This comes with a special piece of syntax:
`function*` denotes a Generator function vs. a regular function. The implementation of this as a Generator
function enables the concomitant keyword `yield`, which then allowed me to
refactor my `AppService` interface to a class:

```typescript
export class AppService {
	// ...

	*[Symbol.iterator]() {
		yield this.resourceGroup;
		yield this.appServicePlan;
		yield this.appService;
	}
}
```

Note, though, the syntax is slightly dfferent for this implementation as the
`function` keyword has been omitted.

I didn't want to have to remember to update this implementation each time a new
property was added to the class, though, so a bit more reading led me to
`Object.values()`. Arrays are iterable by default in JavaScript, so this seemed
ideal, and, indeed, the implementation became a whole lot simpler:

```typescript
*[Symbol.iterator]() { return Object.values(this); }
```

I then realised that this was test-only code, so I moved it to a helper function
in my test suite, and suddenly I could undo much of the earlier cruft, reverting
the AppService type to be an interface rather than a class, and, most
importantly, my idealised test compiled, ran successfully, and passed! :tada:

The subsequent helper function is fully reusable and general purpose, so feel
free to grab it from here if you wish. I'm not making it an NPM package, because
if there's one thing we should have learned from the left-pad incident, it's
that Not Everything Needs To Be On NPM.

```typescript
const spreadable = (object: object) => ({
	...object,
	[Symbol.iterator]: Object.values(object)[Symbol.iterator]
});
```

If you have an implementation neater even than this, I'd love to see it: [send
me a tweet](https://twitter.com/alastairs)!
