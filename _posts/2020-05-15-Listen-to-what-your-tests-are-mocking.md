---
title: A Complete Guide to Testing Your Software, Part 2
author: Alastair Smith
category: testing
created: 1589571968
published: 1592757867
tags:
        - testing
        - craft
        - TDD
        - design
        - ports and adapters
---

## <small><i>or, Listen to what your tests are mocking</i></small>

You might remember from [last
time](/testing/2020/04/26/complete-guide-testing-your-software-part-1.html) that
we briefly covered the concept of [Hexagonal
Architecture](<https://en.wikipedia.org/wiki/Hexagonal_architecture_(software)>),
or "ports and adapters" as it's sometimes otherwise known, in the context of
using mocks and stubs to resolve some of the pain of integrated tests. I wanted
to come at the problem from a slightly different angle for this blog post:
listening to the tests we write, for what they're telling us about our design.
Let's take a look at an example in C#:

```csharp
public class Recorder
{
    private readonly ILogger _logger;

    public Recorder(ILogger logger) => _logger = logger;

    public void Record(bool isA)
    {
        if (isA)
        {
            RecordA();
            return;
        }

        RecordB();
    }

    private void RecordA()
    {
        _logger.LogInformation("A happened");
    }

    private void RecordB()
    {
        _logger.LogInformation("B happened");
    }
}
```

This is contrived code for sure, but the overall shape is common. It might be

- a log statement in the success case or a different log statement in the error
  case;
- registering a discount for a purchase because it's February and the customer
  was born in a leap year, or not;
- any other mutually-exclusive pair of states.

Paint your own domain over this structure, and then ask yourself the question
"how do we unit test that logic"? If you answered "Mock the ILogger and expect
LogInformation to be called", then read on...<!--break-->

### Testing the Recorder

Using a mocking library, this might look something like the following tests
(written with Xunit.net and NSubstitute in C#):

```csharp
public class RecorderFacts
{
    [Fact]
    public void Logs_A_happened_when_A()
    {
        var logger = Substitute.For<ILogger>();
        var sut = new Recorder(logger);

        sut.Record(isA: true);

        logger.Received(1).LogInformation("A happened");
    }

    [Fact]
    public void Logs_B_happened_when_B()
    {
        var logger = Substitute.For<ILogger>();
        var sut = new Recorder(logger);

        sut.Record(isA: false);

        logger.Received(1).LogInformation("B happened");
    }
}
```

Referring back to _Growing Object Oriented Software, Guided by Tests_ (GOOS) by
Steve Freeman and Nat Pryce, we have the advice "only mock types that you own".
What does "ownership" mean in this case, and why is this advisable? Let's
examine things we _don't_ own.

At the most obvious level, it is any type that comes from a published package,
such as those on nuget.org or npmjs.com. You (probably) didn't write the library
you're consuming, and you're not in control of the API of it. Mocking and
stubbing this library is going to result in brittle tests—i.e., tests that fail
because of a change in something other than the system under test—because any
change made to a method signature you have mocked is more than likely to cause
the tests to break, or even fail to compile. If you're using a library with a
stable API, though, you're not going to see these issues. The bigger problem is
that **you are reimplementing the library** with mock methods, and there are two
aspects to this problem.

The first is that you are encoding your expectations of the behaviour of the
library without actually using the library. Say for example the logging library
is somewhat fault and doesn't write a line terminator at the end of each
statement, and instead you have to supply the line terminator yourself. You come
to depend on this behaviour—this _bug_—and it is encoded into all your tests
mocking the library. A new version of the logging library is released which
fixes the bug, your tests all continue to pass, and your logs in production are
all separated by a completely blank line.

The second issue with reimplementing the library in mocks is that, if you care
about the correct use of the library, **it can only be integration tested.** "Oh
no... integration tests are evil..." No, they're not; they're an essential part
of our testing toolkit, and work perfectly well when focused on the integration
with that library. If you mock your external dependency, you are not testing
your integration; your entire test suite can pass, and you still deploy broken
code to production.

The truth of the matter is that the same applies to any internal packages you
consume as well. If you're pulling in a library from _any_ package feed, it
should be treated as a third-party dependency, as though you don't own it.
Ownership is not about who wrote the code, it's about whether it changes on the
same cadence as the project you're testing. As a result, it might be that module
references within the same project (or project references within the same
solution, in Visual Studio terms) need to be integration tested.

So what is "code we own"? I think of it like this:

> Does making a change in dependency `A` to support class `Foo` have
> ramifications for other modules? If not, I own this
> code and can safely mock it.

If we have to verify log statements, as we've chosen to do here, we should use a
real logger for doing that, because we are seeking to verify our integration
with the logging library. There are various test-friendly adapters for libraries
like Serilog, etc., which log to an in-memory data structure rather than a file
or the console. Even if we don't have the option of using one of those adapters,
we have the option of integrating with the console directly:

```csharp
[Fact]
public void Verify_messages_written_to_the_console()
{
    var stdout = new StringWriter();
    Console.SetOut(stdout);

    var expected = "A message written on standard output";
    Console.WriteLine(expected);

    Assert.Equal(expected, stdout.ToString());
}
```

If your logger is configured to write to the console, the `StringWriter` and
`Console.SetOut()` technique will still work for you; the Console is a static
resource, after all.

In conclusion, the lessons we've learned here are:

1. **Mock only types you own.** Make sure you're testing what you think you're testing.
1. **If you don't own the type, you're integrating with it.** Test your
   integrations with integration tests, not mocks.
