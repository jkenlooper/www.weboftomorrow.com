# Clever Bits of Awesome Mud Works

[Awesome Mud Works](http://awesomemudworks.com/) is all about pottery classes
and displaying some cool ceramics. I decided to build this site as a project
that I could further research docker tools. Although it is just a simple site
with a few pages, it does do a few clever things that I would like to
highlight.

This site was also designed by me. Designing websites is harder then it looks.

## Intrinsic Ratio with CSS Custom Properties

I'll start off with something a little easier to explain before I get into the
weeds. This one actually didn't take long at all to put together and it worked
so well that I was just simply proud of it.

The problem that I had was the common problem of embedding a map into a web
page. The iframe is a set width and height, but I needed it to resize if the
browser width was smaller. I also wanted it to take up the full width if the
browser width was larger then the map. Like I said, this is a simple common
problem that has been fixed before using a technique called intrinsic ratio.

[chill route /snippet/awesomemudworks.com/normal-intrinsic-ratio.css/css/]

Oh, but we have CSS custom properties now! I can just use inline style to set
these and now there is no more need to set ratio modifiers.

[chill route /snippet/awesomemudworks.com/gist-intrinsic-ratio-css/5-utils-intrinsic-ratio.css/css/]

An example of the HTML to embed a map into the page. Note that I'm using the
inline style to set the two custom properties.

[chill route /snippet/awesomemudworks.com/gist-intrinsic-ratio-css/example.html/html/]

Done and
[I made a gist](https://gist.github.com/jkenlooper/55f5a6a001937bc8bde408ff03a80f97).
Now the google map here will simply resize and keep the desired ratio without
need to update the CSS. I just felt so clever after doing that.

## Contact Details with Recaptcha and a Twist

Okay, next up is the common contact us page. This one actually started off
with being a standard contact form protected by a recaptcha challenge. Don't
want a bunch of robots filling out contact forms with junk, right? Oh, contact
forms are so ... well, not for humans. Why would a small business (really,
just one person) want to have potential clients filtered through a contact
form?

My thought is that you want to develop that one on one communication quickly.
Having the preferred way of contact to be filling out a form, with say your
email address, raises a question of what happens with your email address after
you hit submit. Does it get stored in some database and then used to send out
unsolicited email newsletters? Who knows?

But, we still want some protection from robots, right? Can't just be putting
the email and phone number on a website like this and expect the owner of it
not to get put on all kinds of junk email lists and such (no guarantees on that
of course). But, for the humans out there, they need a simple way of
contacting the business. So, I still had the Recaptcha stuff working, I just
needed to tweak the page into displaying the contact details after the
recaptcha was solved.

Ah, look, the recaptcha can actually be done invisibly now in the background.
Google already knows who is a robot and who is human for the most part (they
are clever like that). So now when you load the page it checks to see if you
pass the test and inserts the contact details into the page on success.
Hooray!

Oh, but why check again if you are a robot if you revisit that page? That
would be silly, right. Time to use some local storage for the win. So, I'll
just keep a checksum of the contact details content in local storage and
compare that. If they still match then the user can see the contact details
without the need to verify their anti-robotoness. When the contact details
change the checksum will no longer match and then they would need to reverify,
no problem.

I saw this one as pretty useful and figured I could use it in other projects.
I pulled out the bits into a git repo here as
[Anti-robot Snippet](https://github.com/jkenlooper/anti-robot-snippet).

## A slightly Over Engineered Approach to an Image Gallery

CSS grid is cool and I wanted to use it in a cool way. I have a folder of
pottery pictures like mugs, plates, bowls, and all that. I also have `convert`
and `make` on my machine (who doesn't, right). What happens when you combine
these things? You get a gallery page that shows 6 pictures of some handmade
ceramics.

<figure>
<img class="u-leash" src="/media/awesomemudworks-gallery-6x4.jpg" width="400" height="271">
<figcaption>6x4 layout</figcaption>
</figure>

<figure>
<img class="u-leash" src="/media/awesomemudworks-gallery-4x6.jpg" width="400" height="603">
<figcaption>4x6 layout</figcaption>
</figure>

<figure>
<img class="u-leash" src="/media/awesomemudworks-gallery-3x8.jpg" width="200" height="532">
<figcaption>3x8 layout</figcaption>
</figure>

Oh, but look at this bit of Makefile madness that got a little too clever.

[chill route /snippet/awesomemudworks.com/gist-gallery-mk/gallery.mk/makefile/]
I made a [Gist of the gallery.mk](https://gist.github.com/jkenlooper/1529699c7cf5bd2e66669d930461f673)

At least I kept it less clever on the cropping and resizing from the source
images. I manually set each cropped and resized image like this. Brings new
meaning to _Lovingly hand-crafted website_.

[chill route /snippet/awesomemudworks.com/image-convert.mk/makefile/]

Now for the automatic layout depending on browser width (responsive design, ya
know). The design constraint? I basically keep the layouts to have a total of
24 cells and all 24 cells need to be filled. For my six pictures I set three
of them to be in a 3:2 ratio and the other three are 1:2. That way they fill
all 24 cells when laid out in a 6x4 layout, 4x6 layout, and 3x8 layouts. I also
simply stack them when viewing at even smaller widths.

I think going over detail of the CSS for the gallery grid would be out of scope
for this article. If you are curious; check out the [gallery on Awesome Mud
Works](http://awesomemudworks.com/gallery/) with your browser dev tools.

## Using docker for the first time in a web project

I'll confess; near the end of publishing this project I finally understood when
to use a volume versus a bind-mount in docker. It does help to actually read
the documentation closely instead of being surprised or confused why something
doesn't work.

I split up my project into having a few containers. I use a NGINX container
with a production and separate development config. A chill container that
creates a static site in production or database driven one in development. For
the fancy contact details page, I have an api container that is a python app.
And then a container that runs awstats since I thought that would be cool.

Still trying some things out with this setup, but I think it works well enough.
The deployment process was a bit different then I was use to, but it worked.

I created a seed project of my docker setup that is based off of this site.
The cookiecutter project is on GitHub as
[cookiecutter-chill](https://github.com/jkenlooper/cookiecutter-chill).
