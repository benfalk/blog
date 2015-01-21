---
layout: post
title: "Erlang Map Pattern Matching"
date: 2015-01-20 20:24:46 -0600
comments: true
categories: 
- Erlang
---

One of the new _hot topic_ items in Erlang R17 is maps.  In Ruby you would call
them a hashes, PHP calls them associative arrays, no matter what you call them
it's the same idea: key-value pairs.  Back in the *"Good old days"* :tm: an
Erlang programmer would need to leverage a record to get the same functionality.
While records are very good and carry benifit they lack some of the flexibility
found in maps.

<!-- more -->

Defining a map is pretty strait forward.  The `#{` starts it off and then is
followed by any number of `key => value` pairs that are seperated by commas
before being terminated by the lonely `}`.

``` erlang
Spot = #{breed => "Mutt", age => 5, color => "Tan"}.
```

Lets say we want to build a fun that will up the age by one, to do so we could
write it like this:

``` erlang
OneYearOlder = fun(Dog = #{age := N}) when is_integer(N) -> Dog#{age := N + 1} end.
OneYearOlder(Spot). % => #{breed => "Mutt", age => 5, color => "Tan"}
```

It is important to know the differance between the `:=` and `=>` operators.

`:=` will only work for pattern matching or updating a key from a map that has
that key already defined.  As in this example the _brightness_ value cannot be
updated from _sun_ as it was not one of the original values.

``` erlang
Sun = #{age => "Pretty darn old", size => "Huge!" }.
Sun#{brightness := "Insanely Bright"}.
% ** exception error: bad argument
%      in function  maps:update/3
%         called as maps:update(brightness,"Insanely Bright",
%                               #{age => "Pretty darn old",size => "Huge!"})
%      in call from erl_eval:'-expr/5-fun-0-'/2 (erl_eval.erl, line 255)
%      in call from lists:foldl/3 (lists.erl, line 1261)
```

`=>` can be used to initialize, add, or update map values.

``` erlang
Sun = #{age => "Pretty darn old", size => "Huge!" }.
Sun#{brightness => "Insanely Bright"}.
%=> #{age => "Pretty darn old", size => "Huge!", brightness => "Insanely Bright" }
```
