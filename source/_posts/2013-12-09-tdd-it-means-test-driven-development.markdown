---
layout: post
title: "TDD - It Means 'Test Driven Development'"
date: 2013-12-09 22:41:01 -0500
comments: true
categories: 
- Code
---
It's probably only been the last couple years that I have really fallen in
love with TDD.  It helps keep your focus on quality by letting you write
code that you wish you had.  The implementation doesn't matter, in fact it
is the least of your concern.  That is the beauty of TDD.

<!-- more -->

It gives you the ability to throw together shabby code that does what you
want it to do.  Then, when you are feeling froggy you can go back and make
the implementation better.  The key to this is to write your tests first!
Write each test for classes and methods you haven't even written yet and
watch the tests go "from red to green."

Why?  If you write your test afterwards it requires a follow-up discipline
that few can keep going.  Worse, you'll find yourself writing tests that end
up being tightly coupled with your less then perfect code...  When it comes
time to refactor your code you'll end up commenting out your coupled tests and
never get back to them.

If you're not writing tests to help drive the development of your code there
is a good chance you're doing it the hard way.  Unless your hacking together
code you don't plan to be in production six months from now you should really
look into TDD.  I reached a new level of quality and productivity when I 
started developing in this fashion and it's my hope you will to.

If you're writing tests after you've written your code, that's just automated
testing.  The other way around is *Test Driven Development*
