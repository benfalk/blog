---
layout: post
title: "json_pp with Vim"
date: 2015-08-31 17:12:58 -0500
comments: true
categories: 
- Vim
---
In another [post](/blog/2015/08/07/command-mode-tricks-in-vim/) I showed you
some tricks you can do from command mode.  If you aren't familiar with it, most
standard Linux distros ship with `json_pp`, which is a pretty-printer for JSON.
Today I discovered this tool makes for a fantastic quick tool in Vim when you
want to sharpen up some JSON.  It can take output like this:

``` json
{"rofl":{"copters":["red","blue","gree"]}, "lol": 24.6}
```

And turns it into this:

``` json
{
   "rofl" : {
      "copters" : [
         "red",
         "blue",
         "gree"
      ]
   },
   "lol" : 24.6
}
```

Using the following command

``` vim
:1,1!json_pp
```

In this case the `1,1` part of the command is the range of lines that you want
to send to `json_pp`.  This also works with visual mode as well.  After
selecting the text you want, if you press `:` it will pre-populate the correct
range for you!
