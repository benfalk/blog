---
layout: post
title: "Erlang's maps:to_json Not Found"
date: 2014-10-07 09:40:46 -0500
comments: true
categories: 
- Erlang
---
I have been wanting to learn Erlang for quite some time, and last spring I
bought the book
[Programming Erlang: Software for a Concurrent World](http://goo.gl/xYyQ0d)
to begin that journey.  I read about 70% of the book and then life handed me
some curve balls that suspended this great journey until recently.  I rebooted
my learning with Erlang by going through the book and doing the exercises at
the end of each chapter. (Bonus: those exercises are under git if you are
interested [programming_erlang](http://goo.gl/WUgFVX) .)  All was fine until I
got to chapter five and learned of this disconnect...

<!-- more -->

Joe Armstrong describes three `BIF`s, "built in function", that ship with R17
of Erlang to convert JSON to maps

* `maps:to_json(Map) -> Bin`
* `maps:from_json(Bin) -> Map`
* `maps:safe_from_json(Bin) -> Map`

Delving into that module from `erl` tells a different tale unfortunately...

```erlang R17 Maps method list
maps:module_info(exports).
% [{get,3},
%  {fold,3},
%  {map,2},
%  {size,1},
%  {without,2},
%  {with,2},
%  {module_info,0},
%  {module_info,1},
%  {values,1},
%  {update,3},
%  {remove,2},
%  {put,3},
%  {new,0},
%  {merge,2},
%  {keys,1},
%  {is_key,2},
%  {from_list,1},
%  {get,2},
%  {find,2},
%  {to_list,1}]

```

So, what gives?? Why the missing json methods?  A bit of googling and you'll
find this:

>I have not read Joes final book on the matter (several drafts though)
>.. and I've told him, twice I think, that there will *not* be any maps
>to json BIFs to in the maps module. It does not belong in the standard
>library.
>
> Björn-Egil

This Bjorn seems like quite the hard-ass, with the power to lay down ultimate
authority on these maters.  Just who does he think he is?!?!  Well it turns out
he's a dude who knows what he's talking about.  After a bit more digging into
the issue it turns out that turning JSON into Erlang is not a strait solution.
The keys can be represented in serveral different ways and there are already
libraries out in the wild handling them in different ways.

TL;DR;

How do you want your keys?  `<<"key">>`, `[107,101,121]`, or `key` ? Rather
than impose a single standard pick a library that works the way you need and
expect it to.
