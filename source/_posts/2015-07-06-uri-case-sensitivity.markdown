---
layout: post
title: "URI Case Sensitivity"
date: 2015-07-06 23:14:25 -0500
comments: true
categories: 
- http
---
In case you ever run into a problem where you are wondering if urls are case
sensitive or not here is a couple things you'll want to keep in mind.  First the
host and scheme are *NOT* case sensitive.  This means the following list are all
valid.

```
hTtP://benFalk.CoM/index
http://benfalk.com/index
HTTP://BenFalk.COM/index
```

After the host all `non-encoded` characters are considered to be case
sensitive.  This means that if you decide to treat all of the following as the
_same_ route you may want to redirect the requests preferably to the lower case
version.

```
http://benfalk.com/Index
http://benfalk.com/index
http://benfalk.com/INDEX
```

If you have encoded characters, those are *not* case sensitive.  To
explain, if you see a url that looks like this:

```
http://benfalk.com/is übber
```

It will be encoded into the following by the browser:

```
http://benfalk.com/is%20%G%C3%BCbber

%20 = (space)
%G%C3%BC = ü
```

These _"percent encoded"_ characters are *not* case sensitive, so these are
to be considered equal.

```
%G%C3%BC
%g%c3%bc
```
