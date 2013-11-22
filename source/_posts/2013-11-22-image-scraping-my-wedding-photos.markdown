---
layout: post
title: "Image Scraping My Wedding Photos"
date: 2013-11-22 06:13:43 -0800
comments: true
categories: 
- Code
- Ruby
---
It's a rather long complicated story, but the gist of it is I got married to
the girl of my dreams on 7/9/11 and we never got our wedding pictures from
our photographer.  By the powers that be fast-forwarding to now my wife was
able to get a hold of him via phone and he agreed to put our pictures up on
[PhotoBucket](http://photobucket.com/) as well as send us a DVD of our
pectures.  Well it doesn't look like the DVD is coming anytime soon... so
we thought it best to get our images off of PhotoBucket before they vanished.

<!-- more -->

After realizing that PhotoBucket had no way to bulk download our photo album
that was uploaded I took it upon myself to find a less insane way to download
the 410 images.  I cracked open my trusty [firebug](https://getfirebug.com/)
in hopes that the UI was using ajax to fetch my images and I struck gold!
After inspecting the JSON payload that was being used I fashioned my own
script.  If anyone else finds themselves needing to fetch an album before it
disappears this script may give you some help in doing so.

{% include_code ruby/grabber.rb %}

