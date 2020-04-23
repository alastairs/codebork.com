---
layout: post
title: 'An Evaluation of Web Frameworks II.i: Introduction to ASP.NET MVC'
author: alastairs
nid: 62
created: 1227457395
---
ASP.NET MVC is still only a beta, although it has only recently gained this status from the previous "Tech Preview" releases.  The rumour is that it will RTM as part of .NET 4.0.

Despite the beta status, it has a pretty solid feel to it, and it's obviously quite stable: <a href="http://www.stackoverflow.com">Stack Overflow</a> was developed with this framework.  It integrates well with VS 2008 Pro SP 1, and promotes the use of <a href="http://www.alastairsmith.me.uk/coding/2008/09/13/test-driven-development.html">Test-Driven Development</a>, primarily through Microsoft's own Unit Testing framework (also known as MSTest).  However, it will support other frameworks such as my preferred <a href="http://www.nunit.org/">NUnit</a>.
<!--break-->
The first task I undertook was to get NUnit support for test projects integrated into VS 2008, mainly just to see how it was done.  A quick search on StackOverflow.com came up with <a href="http://stackoverflow.com/questions/21137/aspnet-mvc-and-nunit">this question</a> and after a bit of fiddling I'd managed to create myself the option of using NUnit over MSTest.  It was trickier than it probably should have been (including registry editing, yuck), but the blame, such as it is, should be laid at the door of NUnit as much as Microsoft.  I understand there are plans to include a VS 2008 template with NUnit 2.5, but I couldn't find anything along these lines in the most recent alpha release.  

With that completed, I began work on the project itself.  With the ASP.NET MVC framework installed, it presents a new option in the Visual Studio "New Project" dialog box:

[img_assist|nid=60|title=Figure 1|desc=Creating a new web project from Visual Studio|link=none|align=center|width=450|height=306]

[img_assist|nid=61|title=Figure 2|desc=Components of an ASP.NET MVC Solution|link=none|align=right|width=277|height=576]  Once the project is created (complete with Unit Test project), you end up with a Visual Studio solution with a number of folders and other items ready for use (see figure 2).  Let's go through what we've got there.

Firstly, I'll pick out the folders "Models", "Views" and "Controllers".  This being an <a href="http://www.codinghorror.com/blog/archives/001112.html">MVC</a> application, the division makes sense, and actually forces you think in those terms.  Under "Models" go your classes representing the data objects; you'll see I've got classes to represent each of posts, users and comments.  "Views" stores the HTML, in this case as ASPX pages representing templates for the various models.  The "Controllers" are a little trickier, but ultimately all they do is apply the right view to the right model.  In "Controllers" is where the clever stuff happens in an MVC web site, the butler to the Models and their clothes, the Views.  

It's also interesting to note that the default ASP.NET MVC project contains all the necessary workings for not just a homepage, but account management functionality (change password, register, and login) too.  In fact, you can hit F5 as soon as you've created the project and get a working website up in a browser, complete with (admittedly basic) CSS styling.  You do need to create an SQL Server database to get the account management functionality working off the bat.  

There are two "secondary" folders: "Content" and "Scripts".  These are fairly self-explanatory: "Content" holds things like images, CSS files, etc., whilst "Scripts" holds your AJAX and other client-side script files.  It's sad to note that the Beta release of ASP.NET MVC does not include the <a href="http://weblogs.asp.net/scottgu/archive/2008/11/21/jquery-intellisense-in-vs-2008.aspx">jQuery Intellisense</a> file by default, but maybe the <a href="http://weblogs.asp.net/scottgu/archive/2008/02/08/vs-2008-web-development-hot-fix-roll-up-available.aspx">hotfix</a> will resolve that.

What I like about this explicit MVC approach is that it seems to do a good job of separating concerns as far as is possible.  MVC is an important pattern for the web, given the nature of the layers of presentation and business logic that these sorts of applications involve.  It's got some traction at work, although we haven't adopted it as fully as we'd like.  It's very easy in web applications (more so than in desktop applications, it seems) to get the business logic horribly tangled up with the presentation which leads to unmaintainable code, so anything that improves on this situation can only be good.  

The Views (the .aspx files) can be mostly HTML with only the odd bit of C# (or VB if you prefer) to squirt in the necessary bit of data.  I don't know if ASP.NET MVC supports this sort of thing natively, but certainly with the integration with ASP Dynamic Data, you shouldn't even need to do loops to do things like displaying tables of information; instead, you just insert one or two lines of code and ASP will do the rest for you.  Complete with full paging support if required.  There's a bit of (seemingly fairly standard) ASPX at the top of the Views' files to refer to a master template/page, and ensure the 

The Models are just Plain Ol' Objects, business objects in their most real sense.  My Post object, for example, contains properties that map directly to the fields in the database, constructors, and methods for manipulating their state.  They don't need to concern themselves with how they save themselves to the database, or how to present themselves to the world at large.  They just <em>exist</em>.  

The Controllers, as I mentioned before, tie the Models and Views together, and manage external resources, like the database connection.  As such, they are the most complex bit of the application, but because they are separate from the Models and Views, they are much less complex than they might be.  Take, for example, the code to display the "Create Post" form:
<blockcode language="csharp">
public ActionResult CreatePost()
{
    return View("CreatePost");
}
</blockcode>

That's the framework covered... The next post will be on the actual implementation.
