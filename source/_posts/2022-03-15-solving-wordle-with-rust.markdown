---
layout: post
title: "Solving Wordle with Rust"
date: 2022-03-15 00:30:16 +0000
comments: true
categories: 
- Rust
---

Last weekend my brother introduced me to a fun little puzzle game called
`Wordle`.  With it you guess a word and it highlights which letters are
in the word **and** in the correct location or it will signal if the letter is
correct but isn't in the proper location.  After watching a few game rounds I
decided to write something to solve it.

{% img /images/worded-example.png "Worded in Action" %}

The [code is on github](https://github.com/benfalk/worded).

The [demo is self hosted](/wordle-solver/).
