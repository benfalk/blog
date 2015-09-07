---
layout: post
title: "Stop Auto-Connecting to Xfinity WiFi"
date: 2015-09-07 10:13:04 -0500
comments: true
categories: 
- Linux
---
I get so frustrated when Ubuntu automatically connects to `xfinitywifi`.  It is
not much to connect back to my work or home wifi; however, it wastes time and
sometimes can really disrupt my train of thought.  Finally today I had enough
and I looked into how to stop this from happening.  It turns out it's not that
difficult and I wish I would have done this months ago!

<!-- more -->

In Ubuntu click on the "Wi-Fi Networks" manager icon and select _"Edit
Connections"_.  Find the `xfinitywifi` or any other wifi that you have this
problem with, and click _"Edit"_.  On the edit window that appears, uncheck the
_"Automatically connect to this network when it is available"_ option, found on
the _"General"_ tab.  Press the _"Save"_ button and you're set!  I tested with a
couple reboots and no more connecting to the wrong WiFi.

---

{% img left /images/edit-connections.png 250 400 "Edit Connections"%}
{% img right /images/uncheck-automatically-connect.png "Uncheck Automatically Connect"%}

