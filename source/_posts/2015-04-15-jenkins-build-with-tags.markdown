---
layout: post
title: "Jenkins Build with Tags"
date: 2015-04-15 17:08:13 -0500
comments: true
categories: 
- Software Process
---
Today I learned how to set your build process to work off of git tags for builds
versus commits into _master_.

<!-- more -->

Under the *"Source Code Management"* section click _Advanced..._ under your
credentials and make sure that you have this in your *Refspec* field:
`+refs/tags/*:refs/remotes/origin/tags/*`.  Then for your branches to build,
have a branch specifier like this `*/tags/v*-*`.  This will build any tag that
starts with a `v` and has a `-` in it.  The idea here is to have tags that look
like this `v0.1.0-alpha` go down a different flow.

{% img /images/build-any-tag-with-a-dash.png "Build tags with dashes" %}

To then have your other tags that do not have a dash in them picked up in
another build process you'll need to tweak it a bit and set it up like this:

{% img /images/tags-without-a-dash-in-it.png "Build Tags without Dashes" %}

Notice how I have added the inverse strategy option from "Additional
Behaviours".  With this I also needed to add the `*/*` specifier branch so as
to not have the build pick up any other feature branches or other items being
added in.
