---
layout: post
title: "Not a Fan of the Caret in Elixir"
date: 2015-05-10 22:13:29 -0500
comments: true
categories: 
- Elixir
---
Coming from Erlang I'm used to variables being imutable, Elixir doesn't provide
this same level of comfort that I am used to.  For instance, when learning
Erlang we are taught that once a variable is bound it cannot be changed.

```erlang
1> A = "Looking good so far!".
"Looking good so far!"
2> A.
"Looking good so far!"
3> A = "Even better?".
** exception error: no match of right hand side value "Even better?"
```

In Elixir the story is not quite the same...

```elixir
iex(1)> a = "Looking good so far!"
"Looking good so far!"
iex(2)> a
"Looking good so far!"
iex(3)> a = "Even better?"
"Even better?"
```

<!-- more -->

Normally this probably isn't a big deal, I guess, maybe... but it really
starts to suck is when you were hoping to get that sweet, sweet patern matching.
To force the variable in Elixir to not pick up a new value you have to put a
caret in front of the variable.

```elixir
iex(1)> a = "Looking good so far!"
"Looking good so far!"
iex(2)> a
"Looking good so far!"
iex(3)> ^a = "Even better?"
** (MatchError) no match of right hand side value: "Even better?"
```

I'm not sure of what would be a better solution; however, I am not a fan of this
in the language.
