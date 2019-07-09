# An Opinionated Guide on Web Development

Programming started as a hobby of mine and I initially taught myself just enough to get whatever it was I was working on to, well, work. Sometimes it got frustrating, but it kept my interest because I really wanted to implement my ideas. When my hobby transitioned into a full time job where everyday I faced new challenges; I had to get whatever I was working on to work like it was suppose to. My experience was a matter of balancing the research of why I should do it one way and just getting it done. Spending too much time on one and not the other limits your ability to be a good software developer. In my opinion anyways.

This is a summary of opinions that I've made and am continually changing. I decided to write this instead of digging into one of my side projects right now. Actually, this has become yet one more side project for me. Okay, so enough introduction text. The rest will be short, simple and hopefully to the point.

## Terminal in fullscreen running `tmux` and `vim`

My workflow is largely based in the terminal and running different command line applications. `tmux` is super useful in managing all the different sessions and windows I might have.

My text editor of choice is `vim` with a custom set of plugins. Vim can be a very powerful tool that takes a long time to master. The trick is to always be learning and using a new technique with it to be efficient.

I also use many terminal window open at once and to manage all of them I use the program called `tmux`. It allows me to split the window into multiple panes with each being a terminal. I can have `vim` running on one side and the log of some other process in another. With multiple projects; I keep each as a separate session and detach/reattach as necessary.

## Front End Web Development - SoC

A website can be a pretty complex bit of software. It helps to divide it into multiple parts that are independent of each other. You know, the whole separation of concerns (SoC) bit. Isolate each piece into something that can be tested and documented for it's intended use.

For new projects; it's good to take the time to write well structured and semantic HTML first. It helps to break up the HTML into separate components for reusability. Ideally, the HTML component can just be a macro that gets inserted into the page and not continually copied/pasted. When the HTML component gets copied and pasted multiple times, it no longer is a component. To make changes to it would require hunting down all the places it's being used. Obviously, not all things can be implemented this way. In short, use a good templating language, and uhm, organize stuff. Okay? Oh, and documentation does help, but only if it's reliable.

If it's a HTML template for instance, document why it's structured the way it is and what the limits are for the content that will be shown with it. A HTML template shouldn't be concerned about what CSS or javascript will be used on it. If a CSS class or id should apply to elements in the template that are specifically design related then that would be more the concern of the design part and not necessarily the HTML template. For instance if the design changes, the HTML template documentation and intended use shouldn't be affected. _Separating the HTML template from the design in this way sounds like a good idea, but I haven't tried it yet._

Organizing CSS to be more maintainable can get messy. I started out years ago with all the CSS in one big file and organizing it simply with plain elements at the top and then working down through the overall layout of the site and pages. When a redesign of the site needed to happen, that CSS file would usually just be thrown out and I would start from scratch. Doing it that way the CSS is one big 'part' and not easily isolated into separate things. That was before tools to process the CSS code.

It is better to separate CSS into many different files which aids in keeping it isolated from the rest of the design. The goal is to make each part to be a testable and documented thing. **Most importantly is that the CSS code in that file is easily findable and matches the filename.** Testing that CSS code is actually doing what you assume it should be doing requires viewing it in a web browser. Not something easily automated, but it can be done with `pageres` and other programs. The idea is to test CSS for any visual regressions by comparing a before and after screenshot.

## My Method in Developing a Website

The most important part of a website is the content. It's what a potential site visitor is after, it's what the robots look for, and it should be what makes your site unique. I like to start with having a pretty good idea of what and how much content a site requires. The content should be easy to edit by whoever the content editor is before the website is live and after. While the content can be in many different formats, it's preferable to be in simple text or markdown. If the content is in HTML then it should not have any class or id's that are specifically design related. The idea is to not have to worry about changing any content because the design of the website needs updating.

A good styleguide should be created here to show how the design affects the plain elements and such that the content will be in. The problem with styleguides is that they can get out of sync with the rest of the website. There are many solutions to this problem and the one I like uses a macros or api model. The idea is to have a method that is used to generate some specific HTML structure when it's used.

Next is isolating the individual components that make up the various pages on a site. Each component should be documented on it's intended use and what content will be used. It'll be up to the web server to put all these components together to form a webpage depending on the request and such. Create the templates for these components to not care too much about what other components will be contained within them.

I usually develop the CSS for each component after I have a pretty solid HTML structure in place. A test page is created that just shows that single component. If possible the HTML template being used should be the same one that is used in the actual website. That way if something changes in the template then it would be reflected in your tests as well. If the component in question has multiple variations, then these are added to the test page, too.

When it's time to test the various parts of the design I setup the web server to create some testable pages of different sections of the website. So, I'll get it to show a page with just the header and it's navigation menu. On another page I'll have it show the homepage layout but with nothing else. The idea is to split things up so I can better concentrate on the individual parts. These different parts shouldn't be using any real content, so they'll be easier to test with visual regression tools like `pageres`. It's also a good way to test how the different components react when used together.

## Tips when developing CSS

1. Avoid the back and forth cycle. _Edit CSS, Reload browser, repeat_
2. Research the unfamiliar CSS before applying it. [MDN CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference) and [CSS-Tricks](https://css-tricks.com/) are good resources.
3. Set up your text editor to do auto complete.
4. Comment your CSS code when doing something not obvious.
5. Be familiar with the Developer Tools in your browser.

Writing a couple of rules for a selector and then switching to your browser to reload the page and repeating this cycle is inefficient. Try to write your CSS in more complete cycles. Going back and forth between the web browser and the editor takes time, especially if you have to use the mouse. Constantly reviewing things in a visual web inspector is a signal that maybe more time should be spent researching that unfamiliar CSS. On your test pages you could add some 'helper' styles to outline some elements to better show them.

Some tools to better iterate on stuff that is unfamiliar:
[Dabblet](http://dabblet.com/), live reload, maybe an auto screenshot script.

## Visual Testing of Cascading Stylesheets

The best time to write tests is when when the thing is being developed, after finding a rendering issue, or adding a variation. The tests should of course be automated. Writing tests for CSS is all about setting up a screenshot comparison and reviewing the differences between a previous version and the current. Commonly this is called Visual Regression Testing, and there are a lot of tools that can be used for this.

## The Rule of Three

**After using the same bit of code in three different places, maybe it's time to ...** When developing components for a website it will sometimes make sense to reuse components that have already been developed. But, to initially develop a component with the idea that it might be used in other future websites is sometimes an anti-pattern. The problem is predicting the future and how exactly this component will be used. Generally it's easier to just develop CSS from scratch which also reinforces your knowledge of it. When doing something similar for the third time and it's, well, getting boring; then it's a good time to make it into its own separate project. First refactor those three implementations into a single code base. Set it up so it can be imported into each project and by all means use [semantic versioning](http://semver.org/).

Most components should already be pretty isolated, but may have some specific design elements attached to them. These website specific design bits should either be in a typography section or set as variables. Knowing what should be set aside as a variable is more obvious the third time that the component is being applied.

## WIP

This is a bit of a work in progress. The below are some other topics that I may or may not get around to expanding.

- Testing your code
- Reusing and modifying your own code
- To rebuild or remodel - things to keep in mind when refactoring

- Keep up to date on notable changes
- Understand how the stuff works underneath

- Working with others
- When to delegate and/or outsource
- Learn to use other software libraries

- Have a fun side project to keep your skills and interest
- Managing your time and avoiding burnout
