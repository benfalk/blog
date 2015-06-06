---
layout: post
title: "Ruby Inheritance with Super"
date: 2015-06-06 17:59:57 -0500
comments: true
categories: 
- Ruby
---
A couple days ago during a code review one of our developers noticed that we
called the `super` method with no parameters and still had parenthesis.  They
wanted to remove it; however, it turns out in Ruby that `super` does some extra
magic that you need to be careful about.

<!-- more -->

