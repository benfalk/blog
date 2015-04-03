---
layout: post
title: "Vim bindings in Bash"
date: 2015-04-03 14:15:46 -0500
comments: true
categories: 
- Linux
---
About a month ago I found out that you could configure inputs to work similar
to that of Vim.  This of course was a happy find and I would like to share what
I did to get it as close to what I use.

To get it up and going if you don't have an `.inputrc` file you'll need to make
one and add the following lines...

```
set editing-mode vi
set keymap vi
set show-mode-in-prompt on
```

This enables vim bindings with bash, and others that use readline such as `irb`.
When you are in `insert` mode you will see a `+` symbol at the far left side of
the screen and `:` if you are in normal mode.  I have added a bit extras for
myself, namely `jj` as a binding for esc in insert mode:

```
$if mode=vi
  set keymap vi-insert
  # Lets you press 'jj' really fast to get out of 'insert mode'
  "jj": vi-movement-mode
$endif
```

One thing I would love to figure out but haven't had success with yet is
modifying the visuals for when you are in insert mode versus normal mode.  I
would love to change the color of my `$PS2` to yellow or something like that
when I am in normal mode.
