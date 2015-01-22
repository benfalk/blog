---
layout: post
title: "Insane fun's"
date: 2015-01-22 15:15:02 -0600
comments: true
categories: 
- Erlang
---
I ran across an Erlang fun that could recursively calculate exponentials and it
was very perplexing at first.

``` erlang

fun(X) ->
  G = fun(_, 0) -> 1;
         (F, Y) -> Y * F(F, Y-1)
  end,
  G(G, X)
end.

```

This is double the _fun_ from what I am used to seeing.  The outer fun
constructs another fun that is designed to take itself as a parameter.  Mind
blown!

After looking this over for a bit I realized it wasn't tail-call optimized so
after a couple stabs I took it to the next level.

``` erlang

fun(X) ->
  G = fun(_, A, 0) -> A;
         (F, A, N) -> F(F, A*N, N-1)
  end,
  G(G, 1, X)
end.

```
