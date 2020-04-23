---
layout: post
title: 'NxtGen Cambridge: RDBMS, NoSQL and CouchDB'
author: alastairs
nid: 134
created: 1269474284
---
If you've been following the developer hangouts in the last few months, you've probably heard at least a little bit about NoSQL and document databases. You may also have read how they're the best thing since sliced bread, and that NoSQL will be your new <abbr title="Best Friend Forever">BFF</abbr>.  Contrariwise, you may have read some of the <abbr title="Fear, Uncertainty and Doom">FUD</abbr> surrounding the subject and have *cough* a less rose-tinted view of the things.  

Last night, I attended the Cambridge <a href="http://www.nxtgenug.net/ title="NxtGen User Group">NxtGenUG</a> meeting on this very topic, and I intend to distil some of what I learnt in this post; mostly it'll be me riffing around the stuff that Neil covered.  The talk was delivered by Neil Robbins, whose delivery was always energetic, interesting and informative.  The 100mph demo at the end of the talk was both simple and powerful.  He's a great speaker even if his slides were a bit wordy (with one or two being excessively so).  <a href="http://www.twitter.com/NeilRobbins" title="Neil Robbins' Twitter feed">Check him out on Twitter.</a>
<!--break-->
<h3>Background and Context</h3>
Neil began with a bit of background, which proved useful in providing some context to the new NoSQL movement.  <abbr title="Relational Database Management Systems">RDBMS</abbr> such as Oracle, SQL Server, et al. are excellent at mapping relational data, but much real-world data is not relational; in fact, the class of problems that RDBMS has grown in number, and is likely to continue to do so.  

The classic customers-plus-orders example that you get in many "Databases 101"-type courses is not relational, as best exemplified by the OrderLine entity that is always added when normalising data.  Does an order line exist in the real world?  Well, ok, <em>sort of</em> &mdash; there are lines on an invoice, for example &mdash; but it's a trick that needs to be learnt: it's not intuitive.  This is also one of the reasons that denormalisation is sometimes required to juice extra performance from a database.  For some applications, such as Twitter, it makes no sense to enforce the relational model on the data, because the data is network-oriented and only semi-structured.  

When you come to program your system in a good OO language like C#, Java, etc., you quickly encounter the Object-Relational impedance mismatch: your objects don't look like your entities.  For example, your Order object might have some form of collection of products and quantities, and that collection will likely look nothing at all like your OrderLine entity.  You can get around this in a couple of ways: code your objects to look more like your entities (and subvert good OO programming practice in the process), or use an <abbr title="Object-Relational Mapper">ORM</abbr> such as NHibernate.  

You've probably heard me mention ORMs and NHibernate before, and they're a great way to solve some problems, but they add a huge amount of complexity in the process.  For example, NHibernate requires you to map your objects to your entities via an XML file, or via C# in the case of Fluent NHibernate.  When I've worked with NHibernate, I've found this to be a massive overhead in the process, <em>particularly</em> for new projects which are still evolving.  

Which brings me neatly on the next point: RDBMS do not cope well with schema evolution.  When you add a new column to a table, existing rows in the table utilise either NULL or the default value for the column (if a default has been specified).  This means the table then has to be updated with information for the new column; if the new column is a foreign key, for example, this can quickly get very laborious.  

Scalability is an interesting problem, particularly as applied to RDBMS.  Vertical scaling &mdash; buying more memory, CPU, etc. &mdash; is very easy, but quite expensive: server hardware does not come at commodity prices.  Horizontal scaling &mdash; splitting the system across separate nodes, either by data or function &mdash; gives greater flexibility, but is much more complex.  Constraints that you might have been able to rely on the RDBMS to enforce now must be incorporated into the application tier so they are consistent across the various nodes.  The two-phase commit technique used in distributed transactions to enforce consistency <em>reduces</em> the overall availability of the system: the figure is the product of the availability of all the individual nodes.  

Instead of aiming for high consistency as RDBMS do, document databases opt for something called eventual consistency.  This concept states that, across all the nodes in the system, at some point in the future the data will be consistent.  As it turns out, this actually the natural order of things in many scenarios: Neil's example was of a system with an important paper step such as filling out a form.  When the form has been completed, the system is inconsistent: the form has not yet been entered into the computerised portion of the system.  It is not until the form has left the agent's briefcase, been passed to the data entry clerk, and entered into the electronic system that the system is consistent overall.  

As it turns out, NoSQL implementations differ in their aims, so it's important to pick the correct one for your situation.  For example, MongoDB's <abbr title="Unique Selling Point">USP</abbr> centres around performance: it's blazingly fast.  There is some commonality between the implementations, however: they are all aimed at <em>large</em> (huge, enormous, gigantic) datasets; they all target commodity hardware; they all aim for high availability.  Here are the different classes of implementation:
<dl>
  <dt>Key-value stores</dt><dd>Hadoop, Redis, Voldemort, Dynamo</dd>
  <dt>Network-oriented</dt><dd>Neo4J</dd>
  <dt>Object</dd><dd>db4o</dd>
  <dt>Columnar</dt><dd>Google BigTable, Cassandra</dd>
  <dt>Document</dt><dd>CouchDB, MongoDB, Riak, Terrastore</dd>
</dl>

No doubt other implementations are available.

Map-Reduce is another common feature of many of these kinds of databases.  This, simply put, is parallel processing of your data.  Work is pushed to the nodes (rather than data being pulled to them), which then emit results.  This is the Map part of the operation.  The Reduce part is an aggregation, which filters the results.  <a href="http://code.google.com/edu/parallel/mapreduce-tutorial.html">Check out Google's explanation.</a>

<h3>CouchDB</h3>
<a href="http://couchdb.apache.org/">CouchDB</a>, a project of the <a href="http://apache.org/">Apache Software Foundation</a>, is an example of a document database.  A document is no more strictly-defined than as a "self-contained thing".  It can be an invoice; it can be an insurance quotation or policy; it can be an event or a business card.  There are no set fields, and documents can have as many or as few fields as required, and the fields can be of complex types.  Document databases are schemaless, so you could store an invoice, insurance quotation, and a business card in the one store.  

In CouchDB, documents are represented in JSON.  This seems to be well on its way to becoming a standard in this space: MongoDB uses a binary-serialised form of JSON called BSON (I wish they'd called it BiSON).  As such, documents look a little like this:

<blockcode language="javascript">
{
    "key": "value",
    "key": {
        "objectType": "value",
        "integer": 4
    },
    ["arrayItem1", "arrayItem2"]
}
</blockcode>

CouchDB is very simple, and has a RESTful API for interacting with it.  Neil pointed out that the API is not strictly RESTful, but I thought it a bit of a tangent so I won't detail it here (interesting as it was).  It handles multiple versions using something called <a href="http://books.couchdb.org/relax/appendix/btrees">append-only B trees</a>; essentially these are tree data structures to which nodes can only be added.  Each node represents a version of the document, with the leaf node(s) representing the latest version(s).  When necessary, the database can be compacted, which causes the trees to be "wound up": that is, the tree is traversed to the leaf node(s), conflicts are resolved, and the tree becomes rooted at the latest version.

Those optional plurals are important: CouchDB is designed for parallel execution and as such is implemented in Erlang, which has excellent concurrency support.  A further consequence of this implementation detail is that it is designed to crash!  This is better than it sounds: when you get a return value back from CouchDB, you are guaranteed that your data has been persisted to disk.  If something goes wrong in one of the CouchDB processes, it simply hard resets: no lost data.

Further good stuff includes attachments (for binary streams) and its unbelievably <em>tiny</em> size.  However, and this may put some people off trying it out over something like MongoDB, ad hoc queries are not supported.  You can only query via defined views (luckily there are quite a few built in), and the command line interface requires <a href="http://curl.haxx.se/">curl</a> or a similar library/program that allows you to fire off web requests.  There is a GUI supplied with CouchDB, called Futon (available via your favourite web browser at http://127.0.0.1:5984/_utils), but the following curl examples should really help you understand what's going on under the covers.  Interestingly, Futon is stored in an internal CouchDB database as a design document.  

<blockcode language="bash">
$ curl -X GET 127.0.0.1:5984/_all_dbs
</blockcode>

This issues an HTTP GET request to port 5984 running on localhost to retrieve <code>_all_dbs</code>.  A JSON-serialised list of all the databases in CouchDB is returned.

<blockcode language="bash">
$ curl -X PUT 127.0.0.1:5984/invoicing
</blockcode>

This creates the invoicing database in CouchDB.  A JSON-serialised status message is returned.  Note the use of the PUT method here.  It's important to understand the difference between PUT and POST; check out <a href="http://jcalcote.wordpress.com/2008/10/16/put-or-post-the-rest-of-the-story/">this blog post on the subject</a> and the Wikipedia entry on <a href="http://en.wikipedia.org/wiki/Idempotence">Idempotence</a>.  

<blockcode language="bash">
$ curl -X POST 127.0.0.1:5984/invoicing -d @'myfile'
</blockcode>

This inserts a record into the invoicing database, using the contents of the myfile file as the document.  Note therefore that myfile must contain JSON-serialised data.  This JSON is transmitted in the body of the POST request.  A JSON-serialised status, id (a GUID) and revision id (rev, made up of a revision number and a GUID) is returned.  

It's important to note here that <strong>old revisions are not stored indefinitely.</strong>  When the compacting operation I mentioned earlier is executed, the old revisions are lost.  CouchDB cannot, therefore, be used as the basis of a version control system (for example) unless you guarantee that the compacting operation never runs.

<blockcode language="bash">
$ curl -X GET 127.0.0.1:5984/invoicing/_all_docs
</blockcode>

This returns information about all the documents stored in the invoicing database.  You must append the <code language="bash">?include_docs=true</code> query string in order to retrieve the data.  In practice, however, you are highly unlikely to ever need to retrieve information on all the documents: remember, these systems are designed to work with millions or even billions of documents.

<blockcode language="bash">
$ curl -X PUT 127.0.0.1:5984/invoicing/<some GUID>?rev=<some rev ID>
</blockcode>

This updates the document in the invoicing database identified by &lt;some GUID&gt; at revision &lt;some rev ID&gt;.  As before, the rev is made up of a revision number and a GUID.  The rev query string is required here because you can only ever update a revision of a document.  In the process, you create a new revision of the document, and the new rev is returned in JSON form along with the other usual stuff.

To retrieve a document, simply use:
<blockcode language="bash">
$ curl -X GET 127.0.0.1:5984/invoicing/<some GUID>
</blockcode>

This will retrieve the latest revision of a document.  Presumably you can retrieve a specific revision by using the rev query string as before.  

The next example is quite interesting: using attachments to store binary data with your documents.
<blockcode language="bash">
$ curl -X PUT 127.0.0.1:5984/invoicing/<some GUID>/<some attachment name>?rev=<some rev ID> --data-binary @'invoice.pdf' -H "Content-Type: application/pdf"
</blockcode>

Ok, so it's also more involved.  The &lt;some attachment name&gt; is an arbitrary name used by CouchDB to identify the attachment; it doesn't need to match the filename.  Again, we have to specify the rev as well as we are updating a revision of a document.  The <code language="bash">--data-binary</code> bit is an option to curl that indicates that the body of the HTTP request needs to be base64-encoded as it is binary data; the option requires an argument, in this case @'invoice.pdf'.  Likewise, <code language="bash">-H</code> is an option, which allows you to specify extra header fields manually.  In this case, we're supplying the MIME-type to indicate that our attachment is a PDF.  

The attachment can be retrieved in a couple of ways.  Appending the query string <code language="bash">?attachments=true</code> to a GET request for a document returns the base64-encoded representation of the attachment.  To view the attachment in a more useful format &mdash; in a PDF viewer in this case &mdash; add <code language="bash">/<some attachment name></code> to the GET request.

It's taken me WAAAY longer to write this post than I was expecting, so I'm going to wrap up with a couple of quick pointers to other resources.  You can find a <a href="http://github.com/foretagsplatsen/Divan">.NET library for CouchDB called Divan on GitHub</a>, and there's an excellent (and <em>free</em>!) online version of the O'Reilly CouchDB book available from http://books.couchdb.org/relax.  Do check out the further reading list below as well; there are some great posts there.  

<hr />

<h3>Further Reading</h3>
Dare Obasanjo, aka Carnage4Life, posts extensively on web topics:
<ul>
  <li><a href="http://www.25hoursaday.com/weblog/2009/10/29/FacebookSeattleEngineeringRoadShowMikeShroepferOnEngineeringAtScaleAtFacebook.aspx">Facebook Seattle Engineering Road Show: Mike Shroepfer on Engineering at Scale at Facebook</a>  This is a fascinating post all-round, and describes in some detail what Facebook had to do to get sufficient performance out of MySQL (including heavy use of <a href="http://www.danga.com/memcached/">memcached</a>).  They're now heavily investing in their own columnar storage system, called <a href="http://incubator.apache.org/cassandra/">Cassandra</a>.</li>
  <li><a href="http://www.25hoursaday.com/weblog/2010/03/10/BuildingScalableDatabasesAreRelationalDatabasesCompatibleWithLargeScaleWebsites.aspx">Building Scalable Databases: Are Relational Databases Compatible with Large Scale Websites?</a></li>
</ul>

Rob Conery, ex-Microsoft (working on ASP.NET MVC), has recently jumped on the NoSQL meme with MongoDB.  His blog is a custom engine powered by Mongo.  
<ul>
  <li><a href="http://blog.wekeroad.com/2010/02/05/reporting-in-nosql">Reporting In NoSQL</a></li>
  <li><a href="http://blog.wekeroad.com/2010/02/06/nosql-a-practical-approach-part-1">NoSQL – A Practical Approach, Part 1</a></li>
</ul>

<a href="http://highscalability.com/">The High Scalability Blog</a>.  A sort of best practice-oriented blog aiming to share information on how large sites build for scalability successfully.
