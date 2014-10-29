---
layout: post
title: "Too Many Tools in the Field"
date: 2014-10-29 16:50:56 -0500
comments: true
categories: 
- Project Management
---

Earlier in the week I found a logical bug in an open source project I had been
building against.  After double checking the documents to verify I hadn't
mis-understood anything I decided to open an issue for it...

<!-- more -->

The problem boiled down to a problem of parsing a value and interpreting it as an
undefined term if it was absent. In the documentation, if the value wasn't 
specified it was to be considered a certain value by default.  After reading the
code and raising the issue it was to great sadness I read the reply

> Too many tools in the field currently using this...

I totally agree that breaking compatibility is a serous thing; however, we
should all be taking steps to deprecate and release new changes with our
projects.  Saying a change won't happen for this reason is probably the best
way to guarantee eventually the community of adopters will move on to a better
kept library that solves roughly the same problem.
