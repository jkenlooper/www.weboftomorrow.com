# Old CSS Zen Garden example

I wrote this bit of CSS around 2007 when I wanted to create a sample design for
CSS Zen Garden. I didn't ever publish it, and later I archived it. Recently, I transfered the code out of that archive to gitlab. It is now hosted on the gitlab pages service here:
["Road Flower" CSS Zen Garden Sample](https://jkenlooper.gitlab.io/css-zen-garden-road-flower/).
The project files are at this
[git repository](https://gitlab.com/jkenlooper/css-zen-garden-road-flower/tree/master).

This is definately not how I author my stylesheets now.

[chill route /snippet/css-zen-garden-road-flower/sample.css/css/]

So, what have I learned? Well, this was kinda how CSS was used back then.
There wasn't anything exactly wrong with using id in CSS. It almost made sense
to use it for styling elements that should only be on the page once. I used
the class selector for elements that would be on the page multiple times. The
idea behind CSS Zen Garden was to see what design could be made by just
applying CSS and not modifying the HTML. I know now that having the HTML
structure so tightly coupled with the CSS is not for good times.

I also learned that I wasn't much of a designer and shouldn't be designing
websites. Sure, the site has a unique design with some strange borders around
the sidebar headers. My use of applying filters on graphics was, uhm,
different. Oh, and lets right align most of the body text! Yeah, that looks
sweet!

Note the rounded corner background graphics on the `#quickSummary` element.
Using border-radius back then wasn't well supported. That element's width is
now limited to the width of the graphic. Not to reflect too much about the
past, but I remember the days of all the little hacks that had to be done to
simply add rounded corners to things like this. The one I use here was minor.

It looks like I did add some comments to my CSS. Or, well, two that aren't
just commenting out code. I think I just added them to describe why I set
a certain property that way. Looking at the code almost 10 years later; it
would have been better to describe how the element is being styled. For
example, the `#pageHeader` is being absolutley positioned to the top without
a height and has a full width. The child h1 element is then floated right with
a 100px width and a background graphic. All span elements within the
`#pageHeader` are hidden which only applies to the 'css Zen Garden' text here.
This results in a vertical banner on the right with the site's title.
A comment about that would've been useful in the CSS I think.

There are also a lot of <span class="u-textNoWrap">_magic numbers_</span> with
no comment about their value. At this point it's a guessing game as to why the
margin-left is at 384px for `#supportingText`. With a simple site like this
the guesses are easy and it is most likely associated with the sidebar. These
things aren't hard to figure out, but would get unwieldly if the site were more
complex.

Okay, well, there is always room for improvement.
