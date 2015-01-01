---
layout: post
title: "Erlang List Comprehensions"
date: 2014-12-29 18:24:30 -0600
comments: true
categories: 
- Erlang
---
Reading through the book "Learn you some Erlang for Great Good" and learned a
bit more about _List Comprehensions_ than I knew before.  If you are new to the
world of Erlang, you'll soon discover these marvels.  Here is some of what I
know about them...

<!-- more -->

First, what exactly is a list comprehension? It's a way to map and filter
through List(s).  Here is a small example of mapping, it multiples all values in
the list by two.

``` erlang

List = [1,2,3,4].
[X*2 || X <- List]. %=> [2,4,6,8]

```

The `X` matches every element in the list on the right hand side of the `||` and
the values are collected into a new list with the left-hand of `X*2`.  The
matching that happens here will ignore any mis-matches, as in the following
example where non-fruit is filtered out of a list of tuples.

``` erlang

Foods = [{fruit, "Apple"},{vegetable, "Carrot"},{fruit, "Orange"}].
[{fruit, X} || {fruit, X} <- Foods]. %=> [{fruit, "Apple"},{fruit, "Orange"}].

```

This is just one way to filter down items.  Another is to provide any number of
clauses after the match, such as the following.

``` erlang

List = [1,2,3,4,5,6,7,8,9].
[X || X <- List, X rem 2 =:= 0]. %=> [2,4,6,8]

```

These filter expressions must evaluate to either `true` or `false`.  They give
you a more power over what is filtered when simple matching won't work by
itself.

You can have any number of lists, as long as you have at least one!

``` erlang

List = [1,2].
[{X,Y} || X <- List, Y <- List]. %=> [{1,1},{1,2},{2,1},{2,2}]

```

This creates a Cartesian product between the lists, which can be handy at times
when you want to intersect lists perhaps.
