---
layout: post
title: "Caps Lock is the new Ctrl Key"
date: 2015-03-09 16:06:30 -0500
comments: true
categories: 
- Linux
---
If you are on Linux and still using the CapsLock key for it intended use, you
may need to re-think your life choices.  I have recently done just that and have
remapped this near worthless key to Ctrl and it has been heavenly (apart from
still wanting to press Ctrl of course).

If you are on Ubuntu you can remap it by editing the `/etc/default/keyboard`
file.  Find the line that looks like this `XKBOPTIONS=""` and make it looke like
this instead: `XKBOPTIONS="ctrl:swapcaps"`.  This will swap the role of ctrl and
caps lock.  If you just want to kill the idea of CapsLock all together then you
should use the `ctrl:nocaps` option instead.
