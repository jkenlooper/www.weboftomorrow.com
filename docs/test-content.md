### Load the site with test content

To run the site locally with some test content (All content on the
[Web of Tomorrow](http://www.weboftomorrow.com) site is stored elsewhere):

    cat test-content/db.dump | sqlite3 test-content/db
    chill run --config test.cfg

And check it out at on your machine: http://localhost:5000/test/

