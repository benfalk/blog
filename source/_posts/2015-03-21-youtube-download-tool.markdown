---
layout: post
title: "Youtube Download Tool"
date: 2015-03-21 15:05:23 -0500
comments: true
categories: 
- Linux
---
I have been watching the [LCS](http://na.lolesports.com/) on my phone off and on
when I find some spare time and try to keep up on it during the week.  After
getting tired of sketchy wifi spots and burning through my data plan I decided
to find a better way.

<!-- more -->

I found a really good tool called `youtube-dl` that can be installed with a
simple apt-get install on Ubuntu.  Now I can download each weekend's matches,
put them on my phone, and enjoy great un-interupted quality whenever!  I am
thinking of making a script to _sync_ a playlist with this; however, doing it
manually doesn't seem to painful yet.

**Edit:** I built a sync script to fetch weeks of LCS

``` bash get_lcs
#!/bin/bash

# get_lcs
#
# Fetches a week of LCS from YouTube using youtube-dl
#
# Example: get_lcs 8

command -v youtube-dl > /dev/null 2>&1 || { echo >&2 "youtube-dl is required"; exit 1; }

echo "Fetching EU Week $1"
curl -# https://www.youtube.com/playlist?list=PLPZ7h6L6LC7X4ZoUmRssP4GpPyb6pmskf | \
  grep "Week $1" | \
  grep -o watch?v=[\_a-Z0-9\-]* | \
  while read -r line ; do
    youtube-dl "https://www.youtube.com/$line"
  done

echo "Fetching NA Week $1"
curl -# https://www.youtube.com/playlist?list=PLPZ7h6L6LC7X7JyFE14uywro-O6GsDryA | \
  grep "Week $1" | \
  grep -o watch?v=[\_a-Z0-9\-]* | \
  while read -r line ; do
    youtube-dl "https://www.youtube.com/$line"
  done
```
