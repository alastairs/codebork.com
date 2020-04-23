---
layout: post
title: NMock Framework
author: alastairs
nid: 37
created: 1219592070
---
To aid the testing of my personal finance program, I've been making heavy use of the <a href="http://www.nmock.org/">NMock</a> mocking framework for .NET.  This is a cool utility that allows you replace actual code calls with mock code calls, factoring out a lot of complexity of setting up some tests.  For example, I first started using it to mock the <a href="http://logging.apache.org/log4net/" title="Apache log4net">log4net</a> logging framework rather than creating a new logger for each test/suite and passing that around.  More recently, I've found it useful in mocking parts of the plug-in framework that are required by the code but not part of the test (such as the preferences' manager, for example).
<!--break-->
By way of example, here's set-up method from one of my plug-ins' test suite:
<blockcode lang="csharp">
public void SetUp()
{
    mocks = new Mockery();
    logger = mocks.NewMock<ILog>();
    pluginFramework = mocks.NewMock<IFramework>();

    prefsManager = new PreferencesManager();
    Expect.Exactly(4).On(logger).Method("Info");
    prefsManager.Initialise(logger, prefsFile, prefsFile);

    Expect.Once.On(logger).Method("Info");
    pluginBroker = new PluginBroker(logger, pluginFramework);
    Expect.Once.On(logger).Method("Info");
    Expect.Once.On(logger).Method("InfoFormat");
    Expect.Exactly(2).On(pluginFramework).GetProperty("PreferencesManager").Will(Return.Value(prefsManager));
    pluginBroker.Initialise(pluginDir);

    Expect.Once.On(logger).Method("Info");
    messageBroker = new MessageBroker();
    messageBroker.Initialise(logger);

    Expect.AtLeastOnce.On(pluginFramework).GetProperty("MessageBroker").Will(Return.Value(messageBroker));
    Expect.AtLeastOnce.On(pluginFramework).GetProperty("PluginBroker").Will(Return.Value(pluginBroker));
    Expect.AtLeastOnce.On(pluginFramework).GetProperty("PreferencesManager").Will(Return.Value(prefsManager));
}
</blockcode>

The NMock statements are those that start <code>Expect.Number_Of_Times.On(mock_object)</code>.  As you can see, the statements read very much like English, which I think is one of the strengths of the framework.  <strong>You can immediately tell what the expectation of this object is without having to think around the syntax of the framework</strong>.  Note too the heavy use of interfaces: NMock can only mock interfaces, which I think is another strength of the framework.  This focus on interfaces really drives to you programming via interfaces, which is a key part of designing by contract.

So what does this code do?  First of all, it creates a <code>Mockery</code> object, which is essentially a factory object for mock objects.  Next, a mock logger and mock plug-in framework object are created.  A real <code>PreferencesManager</code> is created, and we tell NMock that we expect exactly 4 calls to logger.Info in the <code>Initialise</code> method of <code>PreferencesManager</code>.  The same is done for a <code>PluginBroker</code> and its <code>Initialise</code> method.  Notice here that we're specifying too that the property <code>PluginBroker.PreferencesManager</code> will return a specific value, i.e., the <code>PreferencesManager</code> created earlier.  A <code>MessageBroker</code> is then created in the same way.  Finally, we state that we expect the properties <code>MessageBroker</code>, <code>PluginBroker</code> and <code>PreferencesManager</code> on <code>pluginFramework</code> will return the concrete objects already created.  

At the end of each test, which may contain further expectations of our mocked objects, we can run <code>Mockery.VerifyAllExpectationsHaveBeenMet()</code>, which does exactly what it says on tin (a victory for clear over concise method naming!).  Note, however, that this is an instance method and not a static one, so you'll need to call it on the <code>Mockery</code> object created at the beginning.  

NMock has a certain amount of flexibility in its interface.  For example, you can replace <code>Expect.x</code> with <code>Stub</code>, which is equivalent to <code>Expect.AtLeast(0)</code>.  There is also a raft of quantifiers for expectations in addition to <code>Once</code> and <code>AtLeast(x)</code>, such as <code>Between(x, y)</code> and <code>Never</code>.  

The downside of NMock is that your expectations end up littered with strings referencing parts of the API.  If a mocked part of the API changes, you have to update these so-called "magic" strings with the appropriate new values; it also enforces a certain amount of trial and error when initially testing your expectations.  A framework like <a href="http://www.ayende.com/projects/rhino-mocks.aspx">Rhino Mocks</a> will use the compiler to tell you when you've messed up by allowing you to reference the mocked properties on the mock object directly, e.g.:
<blockcode lang="csharp">
IFramework pluginFramework; // Create stub framework object via Rhino Mocks
IPreferencesManager prefsMan; // Create and initialise preferences' manager as above
pluginFramework.PreferencesManager = prefsMan;
</blockcode>

This is obviously more concise than the NMock equivalent, listed in the last line of the first code block.

Mocking frameworks are a very useful addition to the unit testing toolkit that allow you to abstract away some of the complexities of setting up unit tests.  They can also be used to test that an interface correctly obeys its contract.  Testing the contract should not, however, be confused with exercising the actual code in the implementation.  If you haven't already investigated mocks, why not look at incorporating one such framework into your next project's unit tests?
