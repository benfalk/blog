---
layout: post
title: "CSS Z-Index Issue"
date: 2015-04-17 17:30:41 -0500
comments: true
categories: 
- CSS
---
Up until very recently my blog had a z-index issue where you couldn't click on
my top banner to go back to the root.  The canvas was at a higher z-index than
the `hgroup` which holds my text bits of the banner image.  I tried all kinds of
tricks to get it _forward_ but nothing worked.  A bit thanks to 
[Dave](https://github.com/davidthesavage) from work for helping me with this
fix.  It turns out this was the incantation I needed to make to get it going:

``` css
.header-info {
  position: relative;
  z-index: 2;
}
```

The position relative is the magic sauce in this incantation... not fully sure
how but this to explains what I cannot: [Z-Index Blog](http://goo.gl/KSn1tK).
