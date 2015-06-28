---
layout: post
title: "Ruby and the Repository Pattern"
date: 2015-06-27 20:59:07 -0500
comments: true
categories: 
- Ruby
- Rails
- Programming
---

Something you will notice after working with a Rails application for any amount
of time is that it's easy for your models to get bloated with business logic.
ActiveRecord makes it *very* easy to chuck in non-essential model ideas, such as
complex model validation and callbacks.  For a small Rails project this isn't a
problem; however, as it begins to grow and your models need to change in the
context you're using them this is when you run into problems.

<!-- more -->

More often than not when you get to this point you have to start un-winding all
of the logic that you have baked into your models.  A popular pattern that helps
avoid this from happening is the repository pattern, and a great gem for this is
[rom](http://rom-rb.org/).  At the heart what you get is ActiveRecord, but with
forced separation of concerns.

### The Pros

* higher uncoupled code
* more supported stores
* easier to test (also faster normally)

### The Cons

* larger file code base
* more on-boarding for new developers
