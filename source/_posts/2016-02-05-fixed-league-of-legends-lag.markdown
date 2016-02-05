---
layout: post
title: "Fixed League of Legends Lag"
date: 2016-02-05 15:52:43 -0600
comments: true
categories: 
- Network
- Tech
---
I am a closet fan of the game "League of Legends"; mostly just as a spectator of
famous streamers such as [Trick2G](https://twitter.com/Trick2g).  However, my
wife loves to play the game and plays in the evenings. Things went wayward for
her about a month or so ago when she started having huge lag spikes and high
ping that seemed to start and then never clear up.  Having done network support
in the past I set out to try and solve this problem...

<!-- more -->

I did all of the normal things I could think of such as check the running tasks
on her computer, make sure nothing inside of our network was hogging the
bandwidth, etc.  Everything I checked seemed to suggest the problem was outside
of our home network.  Every test I ran back out from our router was great, so I
quickly began to suspect this problem was further up stream.  After sniffing the
network traffic from League I was able to do some trace-routes to determine the
problem seemed to reside on the connection somewhere between a router in Chicago
and Riot, the company which owns Leauge of Legends.  I contacted others in my
area that also used my ISP and they we're reporting the same problem.

I reached out to Riot tech support with all of the logs they wanted and got
back frankly what I thought was perhaps the poorest tech support response I've
heard in a long time, "Don't play when this is happening...."  After several more
back and forth emails with Riot I decided to give up and try another alternative
which has fixed this problem when it comes up.

What I did was setup OpenVPN on a Digital Ocean droplet out in San Franciso and
installed the OpenVPN client on my wifes computer.  When she starts to have
packet loss she can connect to the OpenVPN server and her packet loss magically
goes away!  I'm sure there are some other methods I could have used to route her
traffic around this problem area, but this seemed like the surest way to go
since I was never able to get the same latency issues through my web-host
droplet that I have running.

If anyone else is having this problem where they get this lag that seems to
start up about the same time everynight this may work for you as well.  Here is
a [walkthrough](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-14-04)
I found for getting a droplet setup on Digital Ocean and installing the client
on your local machine.  If you're just playing the game the $5 dollar droplet is
probly enough for you.

Riot - if you are reading this I would be happy to help you fix this problem;
provided I can work with tech support that stops insisting the problem is on my
wife's computer or is because of something internal to our network.
