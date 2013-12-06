---
layout: post
title: "Google Analytics CLI - Part 1"
date: 2013-12-03 19:57:25 -0800
comments: true
categories: 
- Ruby
- ga-cli
---
I am working on learning the in's and out's to
[Google Analytics](http://www.google.com/analytics/).  I use it with my blog
and it is quite addictive to watch traffic come in with all kinds of yummy
metrics.  The only thing I really don't care for is having to use Google's
web interface to see how my site is doing.  Since I am in the middle of
leveling up my CLI skills I decided to build a command line tool that can fetch
my Google Analytics.

<!-- more -->

A quick search on GitHub brought up no other current projects really doing
anything of this sort which had me feeling pretty good.  My next place to check
was over at Rubygems, since I plan on building this into a gem package. My gem
name of "ga-cli" wasn't taken so I guess it's offical!

I want to build this as a packaged gem and there is an easy way to initialize
it with [Bundler](http://bundler.io/) using the following command...

```bash
bundler gem ga-cli
```

That produces an empty project skelton ready for me to start hacking away on.
I promptly put it into version control and this is what the code looks like
on the [initial commit](https://github.com/benfalk/ga-cli/tree/f0ebfed71d49fbc9b554c0066de8835df39ba243).

After cleaning up the *ga-cli.gemspec* file I used the following commands to
get my blank gem pushed up to Rubygems to stake my claim with the package name.

```bash
gem build ga-cli.gemspec
gem push ga-cli-0.0.1.gem
```

Now my gem is sitting up on Rubygems, you can check it out
[here](https://rubygems.org/gems/ga-cli).  It doesn't do anything yet but
hopefully in the coming nights I can get some more work cranked out on it.
