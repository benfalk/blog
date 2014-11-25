---
layout: post
title: "Collecting URLs in Erlang"
date: 2014-11-25 15:42:50 -0600
comments: true
categories: 
- Erlang
---
In chapter 16 of the book "Programming Erlang" Software for a Concurrent World"
there is an example of reading through a web page and parsing out all of the
anchor tags found in it.  Here is the meat of the code that I found myself
trying to understand for awhile and would now like to explain:

``` erlang 
-export([gather_urls/2]).
-import(lists, [reverse/1, reverse/2, map/2]).

gather_urls("<a href" ++ T, L) ->
    {Url, T1} = collect_url_body(T, reverse("<a href")),
    gather_urls(T1, [Url|L]);
gather_urls([_|T], L) ->
    gather_urls(T, L);
gather_urls([], L) ->
    L.       

collect_url_body("</a>" ++ T, L) -> {reverse(L, "</a>"), T};
collect_url_body([H|T], L)       -> collect_url_body(T, [H|L]);
collect_url_body([], _)          -> {[],[]}.
```

<!-- more -->

The general idea of this code is provide a method of `gather_urls` in which you
pass it a list of text to parse and a list for the second parameter to add found
anchor tags to.

For those unfamiliar, in Erlang variables are bound by pattern matching.  If a
list is passed to `gather_urls` that doesn't begin with `<a href` then it will
not match the method defined on line 4. As long as it's not an empty list it
will instead match the method defined on line 7, which is simply popping off the
lead character and recursively calling itself with the remaining text list.

This will eventually terminate having never matched the first condition of
starting with `<a href` and returning the list passed into the method originally,
or it will match the first method definition. This is where it gets interesting.

When it matches the first method, `T` will match everything else after the first
part of the literal match.  Now that the beginning of the anchor sequence has
been found the collection and discovery of the end of the sequence is delegated
to `collect_url_body`.  A part that had me confused at the start was the
`reverse("<a href")` on line 5.  This is needed due to the reversing effect that
happens by appending to a list in Erlang.  As characters are appended to the
list with the method defined on line 13 they get shoved to the back, causing the
backwards list.

The `collect_url_body` defined on line 12 is very similar to `gather_urls`
defined on line 4.  When it matches the anchor terminator of `</a>` it returns
it's findings back as a tuple, where the first item is the collected URL and the
second item is the remaining tail of the list to process.  Line 12 tripped me up
for awhile as well because I didn't fully understand `lists:reverse/2`.  It is
only reversing it's first argument and appends the second to the end.

Now that I know whats going on the mystery has disappeared; hopefully anyone
else reading this has a little better understanding of Erlang as well :)
