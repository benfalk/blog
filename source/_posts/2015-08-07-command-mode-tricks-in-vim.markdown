---
layout: post
title: "Command Mode Tricks in Vim"
date: 2015-08-07 17:54:18 -0500
comments: true
categories: 
- Vim
- Linux
---
For those who aren't familiar with Vim I urge you to get at least familiar with
it.  It's capabilities at the command line are awesome when working on a remote
box.  This week I stumbled upon a couple new tricks you can do in command mode (
the mode you enter after pressing `:`).

<!-- more -->

The `%` is short for the current file you are working with.  At first this may
not seem all to great; however, it has many applications.  For instance, if you
are playing around with a ruby script and want to run it strait from vim all you
need to type in command mode:

```
:!ruby %
```

You can also learned you can select a range of items and run a command off of
them.  Pretend you have a file with the following information
