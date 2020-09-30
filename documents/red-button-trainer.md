# Red Button Trainer

[Red Button Trainer](http://red-button-trainer.weboftomorrow.com/)
was initially created to simply try out a few different front end frameworks
like React, Vue, and Angular. I wanted something super simple on the front end
to quickly build the same app in each framework. I didn't want to just create
another todo list app, however. This app started off pretty simple, but then
I got carried away with trying stuff out other then the different front end
frameworks.

## The best way to learn something is to apply it

So I had a few ideas of how to develop a project like this and I also wanted to
use a state machine defined with Xstate. After getting around some of the tricky parts with
setting up a build system for the shared libraries and front end
apps, I took some time to learn and apply some ideas I had about using state
machines in my apps.

I define a state machine for the various states of the front end app. This is
made into a visualisation from a .mmd source file. I could have used the
xstate visualizer, but ran into too many problems with getting that working
right. I also liked the more simple nature of using MermaidJS to describe and
work through designing the state machine.

My first working version was with React. This was the first official React app
I built and it came around pretty quick. All the CSS for the app is in a shared
library for potential use of other apps I'll build with a different framework.
I'm sure I made some beginner mistakes with my React app or stuff I could do
better, but for now it works.

## First Release and Feedback

At this point I had a working app built in React and hosted on GitHub pages. It
was indeed super simple; you push the red button when the green light turns on.
It displays your response time immediately after. I jokingly showed this to
a few friends and they actually spent more time at it then I thought anyone
would normally do. It was a challenge to see how quick they could push the red
button. There were also requests to make the red button more exciting and
realistic. I simply styled a button with CSS to be a red circle; which wasn't
very exciting.

I started a search for more exciting red button graphics that I could use in my
app. That is when I stumbled upon Wokwi Elements. They had a pretty cool red
button that was in SVG. Even better, however, is that this button was available
as a web component. Implementing the web component in my React app was
surprisingly simple and worked out well. Then I replaced the other elements that
I originally designed in CSS with other elements from the Wokwi library.

## Second Release

Now I had something more interesting since I used many of the Wokwi Elements.
The next time I demoed it, more people tried to beat their previous response
time and were also sharing their response time on chat by taking screenshots of
the app. Okay, so I obviously will need a back end to start storing each
individual's response time.

I also had to do some quick changes to get around a small exploit that allowed
someone to push the red button multiple times to get a faster response time.
This lead me down a few ideas about how I could build an API on the back end
that was less likely to be cheated. I'd need to change the
front end to accommodate that.

## The API

So I decided to do some research into how to best do an API for an app like this
to use. I've heard about Swagger/OpenAPI before and knew a few things, but had
never actually implemented something with it. I saw this as a great opportunity
to dive in with my simple app since it wouldn't need a very extensive API.

The specification file that OpenAPI uses is written in YAML and is actually
quite readable by itself. I also decided to include the OpenAPI editor and UI to
the red button trainer so anyone could also play around with the API and see the
various responses.

## Work in Progress

At this time of writing is were I left off.

- I'm developing a good API and trying to figure out the right JSON data
  structure that the challenges will be in.

- I want the project to easily be ran locally, but also am liking the idea
  of using some AWS services. Not really sure where I'll go with this.
