# The Chill way of adding code snippets

A code snippet is commonly shown on blog articles and tutorials. They can be
as simple as using the HTML `pre` tag wrapped around the copy/pasted code. Or
a code snippet can be embedded into the page with javascript. These are the
two options that are the simplest methods. I chose to not do either of them.

## The easy way with copy/paste

First, lets see what is wrong with inserting the code directly into the
article. For sure, this is the easiest method. The problem is it's easy to
have errors in the code. It's no longer active code when it's inserted into
a document. The only way to verify that it still works is to copy/paste it
back into the program.

Another major problem is that the code may interfer with the articles format.
It's now at the mercy of my text editor. For a vim user like me, this isn't
a problem as much. But, what happens if I hand the article over to a copy
writer? What could happen is my code snippet could get modifed and I wouldn't
know without copy/pasting it back into the program.

Since this is actually my first time adding a code snippet to an article like
this; I learned a few things. I started this article in the HTML format.
After pasting in the code to the `pre` tag, I noticed that I would need to
manually escape all the HTML tags that were in the python strings. Well, of
course I didn't want to do that, so I switched the articles format to markdown.
Markdown has
[code blocks](https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet#code)
which I use here.

<!-- flaskstatic.py -->
<h3>flaskstatic.py</h3>
<p class="document-Example-flaskstatic">Script to statically serve a directory with the Flask web framework.</p>
<!-- An element with the class document-Example-flaskstatic must be right before this code block. -->

    #!/usr/bin/env python
    import os

    from werkzeug.serving import run_simple
    from flask import Flask, send_from_directory, render_template_string, abort
    from livereload import Server, shell

    app = Flask(__name__, static_url_path=os.getcwd())
    app.debug = True
    CWD = os.getcwd()

    directory_listing = """
    <a href="/{{ updirectory }}">
    /{{ updirectory }}
    </a><br>
    {{ directory }}<br>
    {% for file in files %}
        <a href="{{ directory }}{{ file }}">{{ file }}</a><br>
    {% endfor %}
    """

    @app.route('/', defaults={'filename': ''})
    @app.route('/<path:filename>')
    def send_it(filename):
        absolute_filepath = os.path.join(CWD, filename)

        if not os.path.exists(absolute_filepath):
            return abort(404)

        if os.path.isfile(absolute_filepath):
            return send_from_directory(CWD, filename)

        files = os.listdir(absolute_filepath)
        directory = os.path.join('/', absolute_filepath[len(CWD)+1:])
        if directory != '/':
            directory = directory + '/'
        updirectory = os.path.dirname(absolute_filepath[len(CWD)+1:])

        return render_template_string(directory_listing, files=files, directory=directory, updirectory=updirectory)


    if __name__ == '__main__':
        server = Server(app)

        # The `.livereload` file triggers a livereload if it is modified.
        server.watch('.livereload')

        server.serve(
                host=app.config.get("HOST", '127.0.0.1'),
                port=app.config.get("PORT", 4444)
                )

_A little plain looking, and prone to having errors_

## The lazy way with a javascript embed

Yeah, being a lazy programmer is a good attribute to have, but it's important
to be lazy _the right way_. A lazy programmer will use existing solutions
first, before busily writing their own custom solution. That could be an
attribute of a smart programmer, but I'm trying to write about code snippets
here.

Anyways, the alternative is to add the code as a gist on github, and then simply
use their embed code. This avoids the issue of having the code directly in the
article's content, and it can also more easily be verified that it works.
Another plus is that it's under version control. Other people can fork and
improve it.

The drawbacks I found with the embed approach is that it wasn't in the style
I wanted. I _could_ make some custom CSS for the embedded gist, but that
started to smell. It also meant that I was locked in to github's gist service.
Not that that is just terrible; I don't think github gists service is going
away any time soon.

### Example of using a script tag for embedding a code snippet.

    <script src="https://gist.github.com/jkenlooper/ac1d41172363b88ea364cfc7cdaa10f2.js"></script>

<script src="https://gist.github.com/jkenlooper/ac1d41172363b88ea364cfc7cdaa10f2.js"></script>

_github is very lovable_

## The better way?

An attempt at a **Far Superior** method using Chill, git submodules, and
a third party lib for syntax coloring.

<b class="wot-ListItem">
  Should be separate from the content.
</b>
<b class="wot-ListItem">
  Should not *rely* on a third party service.
</b>
<b class="wot-ListItem">
  Can be easily styled and maintained across site redesigns.
</b>
<b class="wot-ListItem">
  Needs to be complex enough to write an article on.
</b>
<b class="wot-ListItem">
  Uses a custom framework with little documentation.
</b>

My first step was to research how to make the code that's inserted have
the proper syntax highlighting. I did a quick [ddg](https://duckduckgo.com) and found
[Prismjs](http://prismjs.com) which is awesome. I needed to show line numbers;
so I also included that plugin. It was also super simple to integrate with the
build system the site uses.

Adding some custom styles on top of what was imported from Prism fit pretty
well. I resisted the urge to make my own theme at the moment, maybe later.
I think I have all the pieces figured out now.
<em class="u-textNoWrap">On to the implementation!</em>

### Vertically Challenged Code (VCC)

[A shortcode](https://github.com/jkenlooper/chill/blob/156883f60f56304e79841aca5251ed1965b210d1/src/chill/shortcodes.py)
is a way to expand a piece of content into something else when rendering. For
Chill, I added the ability to do
[a route shortcode](https://github.com/jkenlooper/chill/blob/5c9154a7e300dc1c81b3f03f8690e27dce8ae4a7/src/chill/public.py#L233)
before. The route shortcode inserts the content from another page replacing
the shortcode text. This makes it super generic in what gets inserted into the
page.

For example, this is a link to a llama joke:
[[chill page_uri jokes/llama/so-fat]]([chill page_uri jokes/llama/so-fat])
the only content is:
"[chill route /jokes/llama/so-fat]"

If I wanted to insert that pages content into this article that I'm writing...
Oh wait, I'm doing that _already_. Okay, to insert that **yo llama joke** using
a shortcode:

<code class="u-textNoWrap">[<!-- Avoid replacing this shortcode -->chill route /jokes/llama/so-fat/]</code>

Which is great for inserting llama jokes, but what about inserting code? The
code insert will need a little bit of HTML wrapping it, so it'll need it's own
template. It will also need to escape any HTML that it may be including.
Simple enough with
[jinja2 and filters](http://jinja.pocoo.org/docs/dev/templates/#builtin-filters).
The
[`readfile` filter](https://github.com/jkenlooper/chill/blob/5cf049048e332b9cb86580280979d8e8812e793e/src/chill/app.py#L178)
reads the file from the document folder.

**templates/snippet.html**

    <pre><code>
    {{ filepath|readfile|escape }}
    </code></pre>

The variable `filepath` will need to be set. It would make sense if that was
set based on the URL route to it. The route rule I initially chose is
`/snippet/<path:filepath>/`. So, if I had a file located at
'documents/my-cool-example.py'; it should display it at the URL:
'/snippet/my-cool-example.py' and use the snippet.html template.

Except I don't want to litter my documents folder with various code snippet
files. They should also live in their own repositories. That's what I liked
about the github gist embeds. So I created a sub directory in documents called
'snippet' to organize things better. Since I already had the documents
directory under version control, I used `git submodule add` to include the
files. If a small snippet file didn't have a separate repo it was a part of;
I could just include it in the same 'snippet' directory as the other git
submodules. Seems pretty flexible and maintainable.

### Wiring it together

With the `chill operate` command and some editing to a few tables in the
database I make it show any files in the documents/snippet directory by using
the route. For some snippet files the source is in another git repository so
I use git submodules to include those.

`git submodule add https://gist.github.com/ac1d41172363b88ea364cfc7cdaa10f2.git documents/snippets/flaskstatic`

Now it's just a simple matter of using the route shortcode like so:

<code class="u-textNoWrap">[<!-- Avoid replacing this shortcode -->chill route /snippet/flaskstatic/flaskstatic.py/python/]</code>

### Making it look pretty

This is how I added the syntax coloring lib. The
[Web of Tomorrow source code](https://github.com/jkenlooper/www.weboftomorrow.com)
is compiled with webpack and uses es6 modules. I've modularized the code the
best I can, so for the code snippets most of that is in the src/code-snippets
directory.

Here is how I include [Prismjs](http://prismjs.com) to my code-snippet module.

[chill route /snippet/www.weboftomorrow.com/src/code-snippet/index.js/js/]

Now update the snippet.html to show the filepath of the snippet. The
<span class="u-textNoWrap">`line-numbers`</span>
and <span class="u-textNoWrap">`language-xxxx`</span>
CSS classes needed to also be added.

[chill route /snippet/www.weboftomorrow.com/templates/snippet.html/html/]

For the CSS I needed to restrict the max-height of the code block and make it
scrollable. I set the filepath of the snippet to be on the right and slightly
smaller. I could have used a utility class like `u-textRight` to align it to
the right, but I didn't want it to rely on that dependency. I had to override
some specificity from the prismjs lib which I documented.

[chill route /snippet/www.weboftomorrow.com/src/code-snippet/code-snippet.css/css/]

## Summary

I chose to write about my experience in adding my own custom solution to code
snippets instead of just using a javascript embed code. My initial plan was to
find various snippets of code I've written in the past that I was proud of or
could be used as reference. Researching how I would include those snippets of
code in my website was my inspiration on writing this article.

The end result of simply including a code snippet into this article.

[chill route /snippet/flaskstatic/flaskstatic.py/python/]
