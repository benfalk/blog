---
layout: post
title: "Just A Ten Minute Fix..."
date: 2015-04-07 19:24:05 -0500
comments: true
categories: 
- Software Process
---
{% img /images/this-is-going-to-take-awhile.jpg "We're Hosed Tommy" %}

At one point or another, we've all been there.  You run across a seemingly small
problem that can be fixed in a jiffy.  Under the surface to your problem;
however, lays a sinister set of traps to more problems.  Just as you begin to
solve one problem, your solution reveals more magnificent issues.

<!-- more -->

If left unchecked you could spin your wheels for days correcting all of these
problems and still be no closer to accomplishing whatever was originally wrong.
When these moments come up it's best to be able to realize what's happening.
You're straying off of the path and getting lost!  Focus back to the first
problem and think more into it.

This sometimes means adding more carefully stacked cards to your already shaky
house you have been working with, but it helps get you back to a _"green"_
state.  Document all of the _-hacks-_ you have put in place as well as other
solutions you've tried that also ended in failures.

This will help provide the materials you need in the future to repair the
foundation of your application.  This is especially true for teams of people
working together.  Everyone can avoid re-learning where items have gone wrong
and can instead spend more time improving the system.  As an example I'll
show two different snippets of build scripts, the one I ended up hacking, and
the one I should have made instead.

```bash my-contribution.sh

if [ -f package.json ]; then
  # Hack, this only works with sudo on Jenkins
  sudo npm install
fi 

```

```bash better-contribution.sh

# 'package.json' files are recognized by npm as libraries to pull down for
# node modules.  More information see https://docs.npmjs.com/files/package.json
if [ -f package.json ]; then
  # TODO: This is a *hack* for the moment to get the build working,
  # it seems other jobs are already running `sudo npm install` in other
  # places and they leave global modules un-modifyable by the jenkins user
  sudo npm install
fi
```

Adding this investment through your code base can pay tremendous dividends.  I
encourge everyone to look back after stumbling onto one of these "ten minute
fixes".  Get back to a _"green"_ state as quickly as possible, and document the
actions you had to take to get it there.
