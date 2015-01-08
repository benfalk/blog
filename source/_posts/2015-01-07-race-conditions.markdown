---
layout: post
title: "Race Conditions"
date: 2015-01-07 18:11:29 -0600
comments: true
categories: 
- Programming
---
Spent all day battling against a race condition, and boy do they suck.  Nothing
seems repeatable about the errors and every test you write seems to pass.  What
kind of beast was I running up against?  One of a high-volume nature that would
only rear it's head when the system was under a large strain of course!

<!-- more -->

When you are faced with one of these suckers the best thing you can do is just
turn to your logs, and challenge every line of code your looking at.

* Am I certain this exception was raised from the same process that says it
didn't complete?
* Is the database the source of the race?
* How much time has passed between statement A and statement B; with that in
mind what could have changed to make it fail that was guarded against elsewhere?

These are the kind of questions I ask to get going when faced with one of these
buggers.  Parallel code is by no means easy, and no language truly frees you
completely from _all_ of the problems related to it.  As time passes you begin
to grow your experience with race conditions and can begin spotting and
narrow down where these problems lay buried in your code.
