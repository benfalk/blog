---
layout: post
title: "Leveling Up my CLI Skills"
date: 2013-12-01 09:16:44 -0800
comments: true
categories: 
- Linux
- Ruby
---
This week I picked up the book *Build Awesome Command-Line Applications in Ruby
2*, which you can find [here](http://goo.gl/J0WaFN).  I have always been a huge
fan of the command line and since I really enjoy writing Ruby applications this
book seemed like a double winner.

<!-- more -->

I am about half way through and so far I am totally digging this book!  The
author has done a great job explaining the expected structure and functionality
any command line style application should have.  It gives some good examples of
designing and developing two different kinds of applications.

The first example covers a simple application that can back up databases for
you in an iteration fashion.  The example introduces a couple handy Ruby libs
that are recommended when building your own application and they are
[Open3](http://goo.gl/XaVPT7) and [OptionParser](http://goo.gl/WCC8eQ).  I
found both of these standard libs that come with Ruby _extremely_ handy.
OptionParser gives you a great way to parse flags and switches that your
application may use and also gives you an added benefit of getting your foot in
the door to supplying documention with the default --help switch.  Open3
provides a way to capture the standard and error output streams as well as the
exit code status of another application that is started by your code. 

The second example provided by the book is a todo list application.  The nature
of this application is a bit beefy and is refered to as an application suite.
An application suite has takes the following format ...

```
 app_name [global_options] action [action_options] arguments...
```

The application is broken down into smaller sub-applications that are called
out by the "action" portion.  Perhaps one of the greatest examples of this is
[Git](http://www.git-scm.com/).  The author details out a couple different open
source libraries that you can use to build a suite and they are...

* [Commander](https://github.com/visionmedia/commander)
* [Thor](http://whatisthor.com/)
* [GLI](http://davetron5000.github.io/gli/)

If you are at all interested in this book I would pick it up and give it a
read.  I'll make another post and sum up the whole book when I finish it, peace
for now!
