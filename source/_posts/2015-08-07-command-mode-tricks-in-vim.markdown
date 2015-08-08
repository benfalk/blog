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

I also learned you can select a range of items and run a command off of them.
Pretend you have a file with the following race results that needed to be sorted
by time.

```
Race results

Gary Coleman, 12:45
Tom Hanks, 10:44
Mark Heart, 10:18
Adam Sandler, 13:45
Kelly Clarkson, 9:52
```

If this where a long list you may want to write a quick script; however, vim's
command mode has your back.  Using the GNU `sort` command you can make quick 
work of this list without ever having to leave vim!

```
3,$:!sort -t , -k 2 -h
```

This will take every line, starting at line 3 until the end of the file, and
send it to the sort command.  Whatever sort comes back with will replace this
selection.  Most of the magic is really in sort.  In this example `-t ,` says to
split fields by a comma, `-k 2` means we want to sort by the second field, and
the `-h` option is "human numeric sort".  Give this a try on vim yourself and
you should get the following result.

```
Race results

Kelly Clarkson, 9:52
Mark Heart, 10:18
Tom Hanks, 10:44
Gary Coleman, 12:45
Adam Sandler, 13:45
```

There's so many options that start cropping up once you start to open this area
of vim.  I've been using it for two years now and it feels like there's always
more tricks to learn!  I may create a new section to my blog and put down all
the tricks that I collect.
