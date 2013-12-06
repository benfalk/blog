---
layout: post
title: "Google Analytics CLI - Part 2"
date: 2013-12-05 19:01:01 -0800
comments: true
categories: 
- Ruby
- ga-cli
---
I have been doing quite a bit of research for Google Analytics and I have
identified some major hurtles that I need to overcome.  One of the biggest is
with how an application is able to get data.  You need to use OAuth and Google
appears to have some serious gates up for "none-browser" applications.  From
the documentation the flow goes as follows...

<!-- more -->

{% img /images/deviceflow.png Limited application authorization flow %}

Not an entirely awful setup, but it will require users to eventually use a
browser to approve the application access to their data.  Of course if you
want to go all the way on the command line, for extra points I suppose you can
bust out [Lynx](http://en.wikipedia.org/wiki/Lynx_%28web_browser%29)!

I haven't laid down any new code on the project yet, but here is the gems it
looks like I'll be using after doing some research.

* [Legato](https://github.com/tpitale/legato) - API Wrapper for GA
* [OAuth2](https://github.com/intridea/oauth2) - Handles authorization
* [GLI](http://davetron5000.github.io/gli/) - rake style dsl for framing app
* [formatador](https://github.com/geemus/formatador) - nice text formating
* [Highline](http://highline.rubyforge.org/) - excellent input libary

This weekend when I have more time to get some good coding time in I'll write
up some [cucumber features](http://cukes.info/) and really get some visible
progress done on it.
