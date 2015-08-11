---
layout: post
title: "Xargs Trick with Vim"
date: 2015-08-10 20:13:52 -0500
comments: true
categories: 
- Vim
- Linux
---
In my previous [post](/blog/2015/08/07/command-mode-tricks-in-vim/) I showed how
you can pipe lines from the buffer and have a command like `sort` filter them.
After playing around some more with it I found a way to have `xargs` filter the
lines with whatever command you want.

```
Here is a list of the hosts that need more information

www.google.com
www.yahoo.com
www.bing.com
```

<!-- more -->

Running the following command is a niffty way to accomplish this

```
:3,$!xargs -n 1 -I LINE sh -c 'echo "LINE\n--------------\n$(dig LINE +short)\n\n"'
```

```
Here is a list of hosts that need more information

www.google.com
--------------
74.125.228.211
74.125.228.210
74.125.228.212
74.125.228.209
74.125.228.208


www.yahoo.com
--------------
fd-fp3.wg1.b.yahoo.com.
98.139.183.24
98.139.180.149
98.138.253.109
98.138.252.30


www.bing.com
--------------
any.edge.bing.com.
204.79.197.200
```

This is a pretty awesome ability to have, and `xargs` really opens up a lot with
what you can do.  I am excited to see what all I can use with this!
