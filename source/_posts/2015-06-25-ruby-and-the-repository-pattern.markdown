---
layout: post
title: "Ruby and the Repository Pattern"
date: 2015-06-25 20:59:07 -0500
comments: true
categories: 
- Ruby
- Rails
- Programming
---

Something you will notice after working with a Rails application for any amount
of time is that is easy for your models to get bloated with business logic.
ActiveRecord makes it *very* easy to chuck in non-essential model ideas, such as
complex model validation and callbacks.  For a small Rails project this isn't a
problem; however, as it begins to grow and your models need to change in the
context you're using them this is when you run into problems.

<!-- more -->
