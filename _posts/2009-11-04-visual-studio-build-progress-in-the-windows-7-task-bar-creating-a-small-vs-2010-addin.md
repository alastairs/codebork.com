---
layout: post
title: 'Visual Studio Build Progress in the Windows 7 Task Bar: Creating a Small VS
  2010 AddIn'
author: alastairs
nid: 115
created: 1257379128
---
<a href="http://www.codebork.com/science-and-technology/2009/02/24/windows-7.html" title="Windows 7 write-up on CodeBork">Windows 7</a> introduces a whole bunch of <a href="http://www.codebork.com/science-and-technology/2009/03/21/windows-7-aero-snap.html" title="Windows 7 Aero Snap">cool features</a>, as I've mentioned here previously.  Sometimes the simplest ones are the most effective, however, and there's nothing simpler or more effective than the in-taskbar progress indicator.  If you haven't seen this already, when you copy a file in Windows Explorer, download a file using IE, or perform any of a number of similar actions that might take a while to complete, the progress information is displayed in the task bar icon for that application.

[img_assist|nid=116|title=Windows 7 Taskbar Progress|desc=This screenshot also illustrates the "Icon and Text" display mode|link=none|align=center|width=400|height=234]
<!--break-->
I've also been playing around with the beta 2 release of Visual Studio 2010 recently.  It is very slick and amazingly solid for a beta release. I'm starting to expect all pre-release software from Microsoft to be this solid!  Most importantly it is <em>fast</em>, and a huge improvement over the dog-slow and borderline unusable first beta.  

I was so surprised that VS 2010 doesn't display build progress in the Windows 7 task bar that I decided to investigate.  First of all, I tweeted <a href="http://www.hanselman.com/" title="Scott Hanselman's blog">Scott Hanselman</a> (Softie and blogger extraordinaire) and <a href="http://weblogs.asp.net/scottgu" title="Scott Guthrie's blog">Scott Guthrie</a>, VP of a bunch of MS products including ASP.NET MVC, Silverlight, WinForms, WPF, Visual Studio Tools for WPF... You get the idea :-)

[img_assist|nid=113|title=|desc=|link=none|align=center|width=505|height=166]

And Scott H was good enough to get back to me almost immediately, pointing me to one of the guys on his team at MS:

[img_assist|nid=114|title=|desc=|link=none|align=center|width=504|height=92]

Well, after a couple of days I got bored of waiting (Pete didn't already have an example), so I decided to look at it myself.  It turned out to be surprisingly easy, although it took me quite a long time to discover the correct APIs and iron out the bugs.  The full project is available on <a href="http://github.com/alastairs/buildprogress/" title="alastairs's buildprogress at master">GitHub</a> (although all the code of interest is covered in this post), and you'll need VS2010 to build and run the add-in, along with the <a href="http://code.msdn.microsoft.com/WindowsAPICodePack" title="Windows API Code Pack">Windows API Code Pack</a>, which provides a wrapper to the COM interfaces to many of the Windows 7 features.  As far as I know, this is intended only to be a stop-gap between the current 3.5.1 version of .NET and .NET 4.0 due to RTM sometime next year.  Beta 2 of .NET 4.0 already includes APIs for working with the Windows 7 task bar, but I didn't use them as I struggled to find documentation on them originally, and they're all WPF-based.  My WPF skills are, well, non-existent, so my attempts this evening to port the plugin to these "native" APIs sadly failed.

When you create a new Visual Studio AddIn project, you get a <code>Connect</code> class auto-generated with a bunch of default event listeners and doc comments illustrating their use.  You also get a public constructor with no arguments that Visual Studio will call when creating the AddIn.  I didn't need to do anything here, so it's left blank (and could, in fact, probably be deleted so the .NET default constructor is called).

<blockcode language="csharp">
namespace BuildProgress
{
    public class Connect : IDTExtensibility2
    {
        // Place your initialization code within this method.
        public Connect() { }
</blockcode>

The first event listener in the file is the <code>OnConnection</code> listener.  This event listener runs when Visual Studio <em>loads</em> the AddIn (contrast with <em>creating</em> the AddIn above).  The listener takes a reference to the Visual Studio instance running the AddIn, the connection mode, a reference to the AddIn itself, and finally an array of custom arguments (passed by reference).  Mostly I ignored these; the generated code contained the first two assignment statements below, caching the references to VS and my AddIn, and of course the reference to VS comes in very handy.  My next step is to subscribe to a number of build events by adding an event handler to the event definitions, such as <code>OnBuildBegin</code>.  For non-.NET readers, the reason += is used here is because event subscription is additive - my <code>OnBuildBegin</code> event handler is added to a list of subscribers to the <code>OnBuildBegin</code> event.

<blockcode language="csharp">
        // Receives notification that the Add-in is being loaded.
        public void OnConnection(object application, ext_ConnectMode connectMode, 
                                 object addInInst, ref Array custom)
        {
            _applicationObject = (DTE2)application;
            _addInInstance = (AddIn)addInInst;

            _applicationObject.Events.BuildEvents.OnBuildBegin += OnBuildBegin;
            _applicationObject.Events.BuildEvents.OnBuildProjConfigDone += 
                        OnBuildProjConfigDone;
            _applicationObject.Events.BuildEvents.OnBuildDone += OnBuildDone;
        }
</blockcode>

Next we declare a bunch of private fields to help out with displaying the progress and a flag to indicate whether or not one or more of the projects failed to build successfully (more on that flag in a bit...!).  

The <code>OnBuildBegin</code> event takes two parameters, build scope and build action<sup>1</sup>.  For the purposes of this AddIn, I don't care about the values of these parameters, so I ignore them.  First of all, I clean up for the new build by removing any existing icon overlay, turning off the progress indicator and resetting the failed build flag to false.  

I then do some simple calculations to work out how many progress points the indicator should move per project.  I found the "number of projects" property easily discoverable via Intellisense.  The Windows API Code Pack <code>TaskbarManager</code> class (a <a href="http://en.wikipedia.org/wiki/Singleton_pattern" title="Singleton Pattern on Wikipedia">Singleton</a>) requires a maximum value for the progress bar, so I set this to (number of projects) x (number of percentage points per project) >= 100.  Finally, I call through to update the progress bar indicator.

<blockcode language="csharp">
        // Generated code
        private DTE2 _applicationObject;
        private AddIn _addInInstance;

        // Used to display progress
        private int _projectProgressPercentagePoints;
        private int _nextProgressValue;
        private int _maxProgressValue;

        // Did one of the projects fail to build?
        private bool _buildErrorDetected;

        private void OnBuildBegin(vsBuildScope scope, vsBuildAction action)
        {
            // Reset any previous build state to ensure we start from scratch
            TaskbarManager.Instance.SetOverlayIcon(null, string.Empty);
            TaskbarManager.Instance.SetProgressState(
                        TaskbarProgressBarState.NoProgress);
            _buildErrorDetected = false;
            
            // Now make some calculations as to what "progress" is.  The progress 
            // is approximately a percentage: 
            // (_numberOfProjects * _projectProgressPercentagePoints may be 
            // greater than 100, e.g., if _numberOfProjects is 3 or some other 
            // non-factor of 100).  
            var _numberOfProjects = _applicationObject.Solution.Projects.Count;

            _projectProgressPercentagePoints = 
                        (int)Math.Ceiling((decimal)100 / _numberOfProjects);
            
            // Set the initial progress values and kick-start the progress 
            // updating
            _nextProgressValue = 0;
            _maxProgressValue = 
                        _projectProgressPercentagePoints * _numberOfProjects;

            UpdateProgressValue(false);
        }
</blockcode>

This next block is the first of the two most interesting blocks (save the best 'til last and all that jazz).  Each time a project finishes building, the <code>OnBuildProjConfigDone</code> event is fired, with a bunch of arguments.  I simply call through to update the progress bar indicator, and pass into that method whether or not the build failed (i.e., was not a success).  <strong>Slight digression:</strong> I don't know why MS have used these long parameter lists for passing around the event arguments.  We are advised when coding for .NET to create a class that derives from the <code language="csharp">EventArgs</code> base class, and wrap all the necessary arguments in our derived class.  For example, here we would have <code language="csharp">BuildProjConfigDoneEventArgs</code> defining a <code language="csharp">Project</code> property, a <code language="csharp">Success</code> property, etc.

Anyway, digression over.  <code>UpdateProgressValue()</code> checks the next value falls within the displayable range for the progress bar, and updates the progress value.  

Here's one of the really cool bits of the AddIn: like the new-style progress bars introduced with Vista, the taskbar progress indicator has a number of different states that affect how it displays.  Normally, it displays as a green bar; when an error occurs it can be made to turn red; while yellow indicates that the work item has paused.  If a build error occurred, I set the build failure flag mentioned earlier to true, and set the progress indicator state to Error.  For the remainder of the build, the progress bar will track in red rather than green, providing instant visual feedback that there is a problem with the build!

Finally, we increment the <code>_nextProgressValue</code> by the appropriate number of percentage points so that it is ready for the next project build to finish.  

<blockcode language="csharp">
        private void OnBuildProjConfigDone(string Project, string ProjectConfig, 
                            string Platform, string SolutionConfig, bool Success)
        {
            UpdateProgressValue(!Success);
        }

        private void UpdateProgressValue(bool errorThrown)
        {
            if (_nextProgressValue < 0)
                _nextProgressValue = 0;

            if (_nextProgressValue > _maxProgressValue)
                _nextProgressValue = _maxProgressValue;

            TaskbarManager.Instance.SetProgressValue(
                        _nextProgressValue, _maxProgressValue);
                        
            if (errorThrown)
            {
                _buildErrorDetected = true;
                TaskbarManager.Instance.SetProgressState(
                            TaskbarProgressBarState.Error);
            }

            _nextProgressValue += _projectProgressPercentagePoints;
        }
</blockcode>

Ok, last method now.  The <code>OnBuildDone</code> event listener is fired when the entire build completes; importantly, it fires <em>after</em> the <code>OnBuildProjConfigDone</code> event.  This takes the same arguments as <code>OnBuildBegin</code>, and again we ignore them.  

This is the second cool feature of the AddIn.  The Windows 7 task bar supports icon overlays, i.e., adding small icons to the task bar icon to indicate some kind of state change in the application.  If you've used TortoiseGit or TortoiseSVN then you'll recognise this concept; a tech preview of Outlook 2010 I have used utilises this mechanism to indicate when you have received new mail.  Here I display a simple tick or cross to indicate whether or not the build completed successfully.  The overlay persists until you run a new build, so you have an immediate and persistent visual indication of whether or not your last build succeeded.  These icons are stored in a resources (.resx) file in the solution, and are retrieved via the Resources API.  

Finally I do a short <code language="csharp">Thread.Sleep()</code> to ensure the progress bar briefly displays at 100% before being reset.  The class name has to be fully-qualified (with its namespace) because another assembly used for AddIns defines a interface called <code>Thread</code>.  

<blockcode language="csharp">
        private void OnBuildDone(vsBuildScope scope, vsBuildAction action)
        {
            if (_buildErrorDetected)
            {
                TaskbarManager.Instance.SetOverlayIcon(
                        (Icon)Resources.ResourceManager.GetObject("cross"), 
                        "Build Failed");
            }
            else
            {
                TaskbarManager.Instance.SetOverlayIcon(
                        (Icon)Resources.ResourceManager.GetObject("tick"), 
                        "Build Succeeded");
            }

            // Add in a small delay so that the progress bar visibly reaches 100%
            System.Threading.Thread.Sleep(100);
            TaskbarManager.Instance.SetProgressState(
                        TaskbarProgressBarState.NoProgress);
        }
    }
}
</blockcode>

That's all there is to it!  Now for some commentary on the Visual Studio AddIn framework and the Windows API Code Pack.  

The Visual Studio AddIn framework is easily explorable via Intellisense, and this will often quickly lead you to the correct property or method for your situation (for simple AddIns, at least).  However, it is <em>massive</em>, and there's a wealth of documentation available that would need to be read for any serious AddIn development.

I found the error messages thrown whilst debugging the AddIn unhelpful to say the least, with "Unknown Exception"s and cryptic error codes appearing all over the place.  Googling the error codes didn't help much, either, and I found that this is not even a beta-quality issue: both VS 2005 and 2008 RTM'd with these same useless error dialogs.  

Given the amount of effort the Visual Studio team has put into "dogfooding" the newer MS technologies such as WPF and <a href="http://www.codeplex.com/MEF" title="Managed Extensibility Framework">MEF</a>, I was suprised to find that creating a WPF-enabled AddIn is not trivial.  Packaging AddIns manually is nigh-on impossible: there is some information available about the packaging format, but not so much on the format of files included in the package, so I was only able to get halfway towards a properly-packaged AddIn.  

I created this AddIn without the benefit of the full VS2010 Beta 2 SDK (I didn't have it installed when I embarked on the project), so it may be that some of the issues I mentioned above are resolved if you bother to use that.  Certainly the packaging problems will go away, from what I've heard.  

The Windows API Code Pack is a useful interim step whilst we wait for .NET 4.0 to reach RTM.  However, I came across a number of issues with apparent non-determinism in the taskbar API that cause some funny behaviour, such as the icon overlay not always being removed when I run my clean-up code, and the icon overlay appearing before the progress indicator has reached its maximum value.  I might be unfairly blaming this on the taskbar API, of course, as it could also be a result of the event listeners running out-of-order.  Of course such things are incredibly difficult to debug accurately or successfully.  

Another thing that stumped me for quite a while was that I couldn't cache <code language="csharp">TaskbarManager.Instance</code> in my code at all; it had to be called explicitly.  This may be a result of the particular implementation of the Singleton pattern that the developers used for the <code>TaskbarManager</code> class, but it took me a while to work it out.  I thought about it some today, and discussed it with my friend and colleague <a href="http://www.analysisuk.com/" title="Steve's Personal Blog">Steve</a> (who's much more knowledgeable on .NET than I), and we couldn't come up with a sensible answer.  Maybe it's one for StackOverflow and <strike>Jon Skeet</strike> Tony the Pony&hellip;

Finally, and most annoyingly, Unit Testing was a no-go, both because of this point and because the <code>TaskbarManager</code> class is closed for <abbr title="Dependency Injection">DI</abbr>.  There is nothing I can feed my AddIn to stand in for the TaskbarManager class during a Unit Test because it does not implement any interfaces, so no mocks can be created.  This goes for the WPF API also.  As such, debugging was slow and painful.  If you know of a way to create unit tests in a situation such as this, I would be <em>very</em> interested to hear of it.  

If you happen to be using VS2010, please <a href="http://github.com/alastairs/buildprogress/" title="My AddIn on GitHub">download the AddIn from GitHub</a> and give it a go.  Feature requests and bug reports are all welcome, and can be logged on GitHub.  

<hr />
<sup>1</sup> Scope indicates how much of the solution is being built: a project, a batch or the whole solution; action indicates what build action is being performed: build, clean, deploy or rebuild all.
