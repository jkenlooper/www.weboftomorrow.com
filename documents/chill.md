# Chill - Database driven web application framework in Flask

[Source code for Chill on github](https://github.com/jkenlooper/chill/)

Chill can be used as a static site generator or run as a web application. It's
built on top of the [Flask web framework](http://flask.pocoo.org/) and uses
a few Flask extensions like
[Frozen-Flask](https://github.com/Frozen-Flask/Frozen-Flask). The application
uses a configuration file and connects to a sqlite database. There are saved
SQL queries that are used to determine what content is displayed depending on
the page route. It's actually flexible enough that I use it to generate the
static version of this site as well as run it as a server that hosts the UI of
[Puzzle Massive](http://puzzle.massive.xyz/).

## History

I started this project in 2012 ([First commit for
Chill](https://github.com/jkenlooper/chill/commit/865945757e5517cad990c2fb1af698f66e9d8f70)),
but even before that, I created a few other static site generator scripts. My
other static generator scripts all used YAML and/or the filesystem to configure
what page would be created for a route. They were also simple enough scripts
that I could easily customize.

My first version of chill actually did not use a sqlite database. It was
basically a script that built a site based on the file/folder structure of
nested folders. Each page within these nested folders would relate to the page
route, and within that folder I could have multiple files that could be pulled
into the content for the page. I had a separate folder to contain all the
templates and other resources like CSS and Javascript.

After I built a few sites with this initial chill version, I noticed where it
was limited. For one site I actually wrote a quick jQuery ajax load call that
injected some content from a different location so it would show where I needed
it. I had to do that since that content wasn't in the same folder as the page
I was rendering. That was one of the reasons I decided to just rebuild it
using a relational database.

### The rebuild v0.2.0

I made a new branch for the rebuild and called it mustached-rival because it
sounded like a cool name. I also planned to break away from using the
[Mustache](http://mustache.github.io/) templates, so the name made sense to me.
I followed [SemVer](http://semver.org/) and was still in initial development
(0.X.X). This version 0.2.0 was marked as not backwards compatible.

My plan was to have the data still organized hierarchically like it was in the
nested folders, but be more accessible in a database. That is why I created
a simple Node table:

[chill route /snippet/chill/src/chill/queries/create_node.sql/sql/]

I'm not going to jump into details here on the whole data structure. In short,
a node entry here can be used to link to other nodes and display their values.
With the Flask web framework, a node can have it's value displayed at a page
route and optionally use a template to format that value.

Even more flexibility in what a node shows for a value can be done by using
a SQL query. If the node's value is null and a query is assigned to it; it
will render the results of that query as the nodes value. Now, if the results
include other nodes, then each of those nodes would also render their value.
That is how I can get all the data that is needed to display on a page by
assigning one node to a page route.

In theory the sql queries don't all need to be `SELECT` type statements. They
can also be `INSERT` or whatever else the sqlite database is capable of. So,
a node could be set to a page route that uses the POST http method and add
something to a table in the database. I actually haven't had a use case for
this, but I wrote the tests, so it _should_ work.
