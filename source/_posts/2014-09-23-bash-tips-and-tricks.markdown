---
layout: post
title: "Bash Tips and Tricks"
date: 2014-09-23 20:04:33 -0500
comments: true
categories: 
- Linux
---
Using the up arrow to run previous commands in bash? If so you're doing it
wrong!  Get to know you're bash history and how you can use it to your
advantage.  When you press the up arrow you are cycling through you bash
history, which you can see at anytime with the `history` command.

<!-- more -->

```bash
history | tail
 1993 tmux
 1994 finch
 1995 cd Projects/blog/
 1996 git pull origin master
 1997 rake -T
 1998 rake new_posts["Bash Tips and Tricks"]
 1999 vim
 2000 history | tail
```

First, say you want to rerun the very last command you just issued, instead
of pressing the up arrow you can use the 'double bang' operator, which is the
last command you ran.

```bash
!!
history | tail
 1993 tmux
 1994 finch
 1995 cd Projects/blog/
 1996 git pull origin master
 1997 rake -T
 1998 rake new_posts["Bash Tips and Tricks"]
 1999 vim
 2000 history | tail
```

Not to bad, but there is more power to `!!` than first meets the eye.  Think of
it as just the text of last command that is replaced as bash picks it up.
Because of this you can tack extra items to the front or end of it.

```bash
!! | grep rake
history | tail | grep rake
 1997 rake -T
 1998 rake new_posts["Bash Tips and Tricks"]
 2001 history | tail | rake
```

You can also run a specific command from history with `!n`

```bash
!1997
rake -T
rake clean # ...
```

My favorite so far is `!?`.  It looks back from the history stack until it
finds a command that a command that matches it.

```bash
!?pull
git pull origin master
From github.com:benfalk/blog
 * branch            master       -> FETCH_HEAD
Already up-to-date.
```

One last trick, say you goofed a command like so

```bash
ps aux | grep tmx
bfalk    18334  0.0  0.0  15944   920 pts/26   S+   22:16   0:00 grep --color=auto tmx
```

You can clean it up with `:s`

```
!!:s/tmx/tmux
ps aux | grep tmux
bfalk     2416  0.0  0.0  15800  1160 pts/2    S+   20:48   0:00 tmux
bfalk     2418  0.2  0.0  25472  2848 ?        Ss   20:48   0:12 tmux
bfalk    18627  0.0  0.0  15944   920 pts/26   S+   22:18   0:00 grep --color=auto tmux
```

The `:s/find/replace` will search through the last command and replace the
first instance of "find" and replace it with "replace".  If you want to replace
all occurrences then use `:gs/find/replace`.  This may seem like a silly thing
but imagine; however, imagine you have hand crafted some long command... With
this you can rectify it quite quickly!

It is hard to clear that muscle memory of using the up arrow to sift through my
bash history, but, hopefully with these commands you'll be able to start saving
time on the command line as you get used to making fewer keystrokes ; )
