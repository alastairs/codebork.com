---
layout: post
title: 'Web Frameworks Evaluation II.iii: Mocking Database Connections in Unit Tests'
author: alastairs
nid: 68
created: 1232806863
---
One of the reasons progress on my web frameworks' evaluation has been so slow of late is that my last check-in broke my <abbr title="CruiseControl.NET">CCNET</abbr> automated build, and, as the good programmer I am, I felt that this needed fixing before I made any more progress.  

I'd written some unit tests for the <code language="csharp">PostController</code> (good) that were accessing the database directly (bad), and for whatever reason the build machine couldn't successfully connect to the database.  A classic case of <a href="http://www.codinghorror.com/blog/archives/000818.html" title="The &quot;Works on my Machine&quot; Certification Program">"works on my machine!"</a>, and, as is usually the case with such things, a good example of poor design.
<!--break-->
First off, my tests were reliant on an external resource to run.  This is not a good thing, as it increases the scope for things to go wrong (as I found out to my cost), and in such a way as to reduce the amount of control the developer has over his tests.  Doubly bad.  

From there, it also pointed to poor design.  The <code language="csharp">PostController</code> knew about the database, intimately.  There were methods liberally sprinkled with SQL; the PostController maintained a connection to the database, including a hard-coded connection string.  In other words, it was all horribly, horribly wrong.  

I quickly came to the conclusion that I needed a Data Abstraction Layer (DAL) that would allow me to mock the database in my unit tests.  My first port of call was to investigate Object-Relational Mapping (ORM) solutions.  As usual, my trusty <a href="http://www.stackoverflow.com/" title="StackOverflow">Stack Overflow</a> came to the rescue, with <a href="http://stackoverflow.com/questions/tagged/orm" title="Questions tagged &quot;ORM&quot; on Stack Overflow">a whole host of questions on ORM</a>; <a href="http://stackoverflow.com/questions/66156/whose-data-access-layer-do-you-use-for-net">"Whose Data Access Layer do you use for .NET"</a> and <a href="http://stackoverflow.com/questions/146087/best-performing-orm-for-net">Best Performing ORM for .NET</a> proved particularly instructive.  Frameworks like <a href="http://www.nhibernate.org/" title="NHibernate homepage">NHibernate</a>, <a href="http://subsonicproject.com/" title="SubSonic homepage">SubSonic</a>, and <a href="http://www.castleproject.org/activerecord/index.html" title="Castle ActiveRecord homepage">Castle ActiveRecord</a> all seemed very good, and particularly feature-rich, but they all seemed far too heavy-weight for my slim and floaty-light blog application.  They were all filed under "E" for "experience" and "F" for "future".  

One response to a Stack Overflow question suggested looking into the <a href="http://martinfowler.com/eaaCatalog/repository.html" title="Repository Pattern from Patterns of Enterprise Architecture">Repository Pattern</a>, as described by Martin Fowler in his book <em>Patterns of Enterprise Architecture</em>.  Like all good design patterns, the Repository Pattern describes a simple solution to a common problem.  A repository is provided for each data type stored (e.g., posts, comments, users, etc.), and an interface is defined for each repository providing basic <abbr title="Create, Retrieve, Update, Delete">CRUD</abbr> support.  This interface is then implemented for each concrete implementation required.  The original pattern seems to provide in-memory and persisted implementations, whereas I only really needed the persisted implementation.  

So, I defined my posts' Repository:
<blockcode language="csharp">
    public interface IPostRepository
    {
        Post GetPostById(int id);
        IList<Post> GetAllPosts();
        bool Save(Post post);
        bool Delete(Post post);
    }
</blockcode>

and implemented this interface on a <code language="csharp">MySqlPostRepository</code>:
<blockcode language="csharp">
    public class MySqlPostRepository : IPostRepository
    {
        private MySqlConnection db;

        public MySqlPostRepository() {
            db = new MySqlConnection(GetConnectionString());
            db.Open();
        }

        public Post GetPostById(int id)
        {
            var sql = "SELECT * FROM Posts WHERE PostId = ?PostId";

            if (id == Post.BLANK_POST.Id)
            {
                sql = @"SELECT * FROM Posts WHERE PostId = 
                        SELECT MAX(PostId) FROM Posts";
            }

            using (var cmd = new MySqlCommand(sql, db))
            {
                var postIdParam = new MySqlParameter();
                postIdParam.ParameterName = "?PostId";
                postIdParam.Value = id;
                cmd.Parameters.Add(postIdParam);

                using (var results = cmd.ExecuteReader() as MySqlDataReader)
                {
                    var post = new Post();

                    if (results.Read())
                    {
                        post.Id = id;

                        post.Title = (string)results["PostTitle"];
                        post.Summary = (string)results["PostSummary"];
                        post.Body = (string)results["PostBody"];

                        post.Author = (int)results["PostAuthor"];
                        post.DateStamp = (DateTime)results["PostDateTime"];

                        return post;
                    }
                }
            }

            return new Post();
        }

        ...
    }
</blockcode>

You can see <a href="http://trac.alastairsmith.me.uk/FrameworksEvaluation/browser/ASP.NET_MVC/trunk/src/BlogApplication/Repository/PostRepository.cs?rev=14" title="PostRepository.cs at revision 14">the full source code for <code language="csharp">MySqlPostRepository</code></a> in my <a href="http://trac.edgewall.org/" title="Trac homepage">Trac</a> <a href="http://trac.alastairsmith.me.uk/FrameworksEvaluation" title="Trac environment for the Frameworks' Evaluation project">environment</a> for the project.

This re-implementation led to a much nicer set of unit tests for the <code language="csharp">PostController</code>:
<blockcode language="csharp">
    [TestFixture]
    public class PostControllerTests
    {
        Mockery mockery;
        IPostRepository postRepos;

        private const string REPOS_GET_POST_BY_ID = "GetPostById";
        private const string REPOS_SAVE = "Save";

        [SetUp]
        public void SetUp()
        {
            mockery = new Mockery();
            postRepos = mockery.NewMock<IPostRepository>();
            
            Post newestPost = new Post();
            newestPost.Id = 10;
            newestPost.Author = 1;
            newestPost.Title = "Test Post";
            newestPost.Summary = "This is a test post.";
            newestPost.Body = "This is my latest post.  It is a test.";
            newestPost.DateStamp = new DateTime(2009, 1, 24, 17, 2, 4);

            Post post2 = new Post();
            post2.Id = 2;
            post2.Author = 1;
            post2.Title = "Post 2";
            post2.Summary = "This is another test post.";
            post2.Body = "This is my second post.  It is a test post.  It has an ID number of 2.";
            post2.DateStamp = new DateTime(2008, 08, 3, 18, 54, 42);
            
            Stub.On(postRepos).Method(REPOS_GET_POST_BY_ID).With(-1).Will(Return.Value(newestPost));
            Stub.On(postRepos).Method(REPOS_GET_POST_BY_ID).With(2).Will(Return.Value(post2));

            Stub.On(postRepos).Method(REPOS_SAVE);
        }

        ...

        /// <summary>
        /// More thorough test, that tests the default Post object (postId = -1)
        /// as a sanity check, and then reads a post from the database.
        /// </summary>
        [Test]
        public void TestReadViewData()
        {
            var controller = new PostController(postRepos);

            // Mock Post
            var result = controller.Read(-1) as ViewResult;
            var post = (Post)result.ViewData.Model;
            Assert.AreEqual("Test Post", post.Title);

            // Stored in the DB
            result = controller.Read(2) as ViewResult;
            post = (Post)result.ViewData.Model;

            Assert.AreEqual(2, post.Id);
            Assert.AreEqual("Post 2", post.Title);
        }

        ...

    }
</blockcode>

Sadly, my <code language="csharp">Save()</code> test is still being re-written as some of the test cases I had are no longer valid with the new architecture.  However, the <code language="csharp">TestReadViewData()</code> test provides a fairly instructive example.  

Before each test is run, the <code language="csharp">SetUp()</code> method is called, which creates two <code language="csharp">Post</code> objects, <code language="csharp">newestPost</code> and <code language="csharp">post2</code>.  These are "mock" objects for the most recently submitted post and the second post submitted respectively.  I use the term "mock" loosely - they're not mock objects in the usual sense of the word (as we'll see shortly), but they are fake posts that we expect to see returned from the mocked <code language="csharp">IPostRepository</code>.  The <code language="csharp">SetUp()</code> method then creates three stubs on <code language="csharp">IPostRepository</code>, two for <code language="csharp">GetPostById()</code> and one for <code language="csharp">Save()</code>.  The stubs expect <code language="csharp">GetPostById()</code> to be called with the argument -1 (a brand new post that hasn't been saved to the database yet, in which case it should return the most recent post, defined as the post with the highest ID), and with the argument 2 (which should return the specific post with ID = 2).  The stub on <code language="csharp">Save()</code> doesn't do anything at the moment, as per my previous note about the <code language="csharp">Save()</code> method.  As you can see from the example above, the NMock framework produces a very nice syntax for defining stubs and expectations, which I go into more detail about in <a href="http://www.alastairsmith.me.uk/coding/2008/08/24/nmock-framework.html" title="NMock Framework">my previous post on NMock</a>.

Note also that there is an element of <a href="http://en.wikipedia.org/wiki/Dependency_injection" title="Dependency Injection on Wikipedia">dependency injection</a> here, specifically constructor injection: the <code language="csharp">PostController</code> now needs to be passed an <code language="csharp">IPostRepository</code> at construction.  Dependency Injection is a form of inversion of control, and decouples <code language="csharp">PostController</code> from the <code language="csharp">IPostRepository</code> implementation, all Good Things&trade;.  This allows me to fully test the <code language="csharp">PostController</code>'s interactions with the <code language="csharp">IPostRepository</code> without requiring a database to be present.  What it can't do, unfortunately, is allow me to test the <code language="csharp">MySqlPostRepository</code> without a database.  That might need something more inventive, or just not be part of the <abbr title="CruiseControl.NET">CCNET</abbr> build.

My next step is to re-factor the <code language="csharp">IPostRepository</code> interface into a generic <code language="csharp">IRepository<T></code> interface so that I don't need to define a new repository interface for each data type.  Luckily, the interface is already generic enough (aside from method names) to allow me to accomplish this quite easily.
