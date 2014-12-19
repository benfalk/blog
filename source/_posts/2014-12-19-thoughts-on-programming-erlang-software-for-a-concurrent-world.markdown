---
layout: post
title: "Thoughts on Programming Erlang: Software for a Concurrent World"
date: 2014-12-19 10:23:48 -0600
comments: true
categories: 
- Erlang
---
I finally finished reading Joe Armstrong's second revision of his book this
week and having never programmed Erlang before it has been a tremendous help.
There are some [issues](/blog/2014/10/07/erlangs-maps-to-json-not-found/)
with information in the book, but for the most part it's pretty rock solid.

### What I was Expecting
  - The book does a great job of building on itself from one chapter to the
  next.  Never is there a time when something completely out of the blue comes
  out at you.
  - Prepares you for R17, which has some really nice features in it!
  - Examples are easy to follow and the exercises re-enforce and help you
  remember each chapter.
  - Highlights pitfalls of introducing concurrency in the wrong places.

### What I Wished For
  - More coverage of OTP in the book.  There is not much mention of the OTP
  framework in the book.  I plan to find another that goes more into this aspect
  of Erlang.
  - A bit more detail on the `-behavior()` tag.  This may relate to the prior
  point of wanting more on OTP.  It would be nice to know how to write your own 
  behaviors and unfortunately this was not in the book.
