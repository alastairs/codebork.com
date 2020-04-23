---
layout: post
title: Message Passing 2
author: alastairs
nid: 27
created: 1217521154
---
As a follow-up to my previous post on <a href="http://www.alastairsmith.me.uk/coding/2008/06/25/message-passing-a-plug-framework.html">message passing in a plug-in framework</a>, I thought I'd post my solution to the problem.  Now that I've finally reached a solution, that is...!

[<strong>Note</strong>: It would be worth reading the first post to get an idea of what I was trying to do.  ]

[img_assist|nid=26|title=|desc=|link=node|align=none|width=480|height=318]
<!--break-->
As you may recall, I was investigating a number of ways of passing messages in my plug-in framework, and was trying to settle on the built-in .NET event system as the underlying mechanism.  Whilst discussing this with my friend and colleague <a href="http://www.analysisuk.com/blog/" title="Steve's personal blog">Steve Harrison</a>, he suggested that I look into the <a href="http://msdn.microsoft.com/en-us/library/system.componentmodel.inotifypropertychanged.aspx">INotifyPropertyChanged interface</a> provided as part of the .NET System.ComponentModel namespace.  

Despite my earlier misgivings about using events in this way, this turned out to be very useful!  Rather than having to declare my own event types, etc., I simply implement the interface as follows:

<blockcode language="csharp">
public class Plugin : IPlugin, INotifyPropertyChanged
{
    // Implement IPlugin to identify this as a plugin
    ...

    // Implement INotifyPropertyChanged to publish events
    public event PropertyChangedEventHandler PropertyChanged;
}
</blockcode>

Easy-peasy &mdash; one line of code!

Now, ideally, listening plug-ins would then subscribe directly to the events published by other plug-ins, but there's no way of doing this in a de-coupled framework.  How does a listening plug-in know what events are available for subscription, or which plug-ins are publishing events?  

To get around this, I introduced IMessageBroker (and an associated implementation):
<blockcode language="csharp">
public interface IMessageBroker
{
    IDictionary<IPlugin, IList<EventInfo>> Events { get; }
    void Initialise(ILog logger);
    void RegisterEvents(IPlugin publisher, EventInfo[] publishedEvents);
    void DeregisterEvents(IPlugin publisher, EventInfo[] publishedEvents);
    void Subscribe(IPlugin publisher, EventInfo e, Delegate handler);
    void Unsubscribe(IPlugin publisher, EventInfo e, Delegate handler);
    IList<EventInfo> GetSubscribedEvents(IPlugin subscriber);
}
</blockcode>

As you can see, the message broker serves registration-type requests (from plug-ins publishing events) and subscription-type requests (from plug-ins listening to events).  The <a href="http://msdn.microsoft.com/en-us/library/system.reflection.eventinfo.aspx" title="EventInfo Class (System.Reflection)">EventInfo class</a> is provided as part of the Reflection feature in C#/.NET, and does exactly what it says on the tin: it provides access to metadata on the event, and can mediate subscriptions.  Using Reflection, a plug-in passes an array of the events it publishes to the message broker, which then stores it in a dictionary (or map for the Java-types out there) of events, indexed by publisher.  Subscribe takes a publisher, an event and an event handler and creates the publish/subscribe relationship between the two plug-ins using the <a href="http://msdn.microsoft.com/en-us/library/system.reflection.eventinfo.addeventhandler.aspx" title="EventInfo.AddEventHandler Method (System.Reflection)">AddEventHandler method</a>.  

Handily, the broker is flexible enough to be able to subscribe any PropertyChangedEventHandler delegate to registered events &mdash; it doesn't have to be part of a plug-in.  This was doubly useful when testing:
<blockcode language="csharp">
public void SendMessageTest()
{
    // Subscribe to the event with a test handler
    PropertyChangedEventHandler propertyChanged = 
        new PropertyChangedEventHandler(PropertyChangedHandler);
    mb.Subscribe(eventPlugin, mb.Events[eventPlugin][0], propertyChanged);

    // Fire the event
    ...

    if (!handlerRun)
    {
        Assert.Fail("PropertyChangedHandler not run");
    }
}

public void PropertyChangedHandler(object sender, PropertyChangedEventArgs e)
{
    Trace.WriteLine("PropertyChangedHandler was successfully called");
    Trace.WriteLine(String.Format("Arguments passed were: {0}, {1}", sender, e));
    handlerRun = true;
}
</blockcode>

So, to summarise and conclude.  The approach I took was a little more complex than might usually be the case in a publish/subscribe model, but this was dictated by the nature of the system.  The use of the INotifyPropertyChanged interface greatly simplified the implementation of the events, and Reflection allowed me to dynamically pass around information about events rather than having to explicitly state it.  The INotifyPropertyChanged pattern also gives me a model on which to base any extension to the pattern that I might need later on.

How easy it will be to introduce a hierarchy or taxonomy of events at a later stage remains to be seen; I don't think it will be particularly easy.  However, my needs are fairly simple at this stage, and although the plug-in framework is intended to be generic, it's still tied to the personal finance program I'm trying to build.  One of my goals is to completely decouple the framework from the program, but we shall see how easy this is.  With the message passing problem solved, I now need to catch up on <a href="http://trac.alastairsmith.me.uk/FinanceProg/roadmap" title="FinanceProg Roadmap">lost time</a>.
