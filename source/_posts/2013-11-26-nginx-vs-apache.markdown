---
layout: post
title: "Nginx vs Apache"
date: 2013-11-26 12:03:14 -0800
comments: true
categories: 
- Linux
---
If you could travel back to the year 2000 and ask me what HTTP server I rolled
with you would get a very loud and proud response of
[Apache](http://en.wikipedia.org/wiki/Apache_HTTP_Server).  Everyone and their
brother who was writing web applications in the opensource space back then
loved using the word LAMP ( Linux Apache MySQL PHP ). That star-eyed developer
now doesn't use LAMP for opensource web, and it was hard going for some time
relearning a new toolset.

<!-- more -->

The content on my site right now is being served with 
[Nginx](http://en.wikipedia.org/wiki/Nginx) and that should give you an idea
to which of the two web servers I prefer.  So you know where I am now, but how
did I get to a place of prefering it over my once go-to Apache?  Several years
back I took on a web job where my employer was dead set on using Ruby as the
language.  Up until then I had been using my trusty LAMP stack so my first
instinct was to change up PHP for Ruby and keep on trucking like I always had.

All other things aside; I finally had a Ruby web application sitting behind
Apache.  The numbers I was seeing with reply times was somewhat depressing.  I
knew that the speed wouldn't be the same as Apache with PHP or that the
blazing numbers I was getting off of my development machine... but it was just
plain terrible.  I distinctly remember getting reply times of roughly 50ms in
development and found myself looking at numbers around the ~300ms ballpark.

Six times the amount of time, let alone the fact the requests where taking
a third of second was unacceptable for me. Upon my search on how to get a
[Rack](http://rack.github.io/) server going with Apache I remembered seeing
tutorials for Nginx.  After exhausting all the performance tips I knew of for
Apache I decided to spin up another server and tested it out.  After the
switch and before tuning I was already blessed with times of ~120ms; which I
felt was pretty acceptable.  After some tuning and socket magic I was able
to get those numbers down to ~100ms.

I am by no means saying Apache sucks and Nginx is the end-all be-all by any
means.  I still think Apache is a fantastic webserver with more features and
modules then you could shake a stick at.  And I am sure that for some companies
out there it is a fantastic solution.  I will always hold a special place in my
heart for Apache; but as for me and my house, Nginx fits the bill quite nicely.

For any of my PHP brethren out there who hold firm to Apache, I urge you to at
least give Nginx a spin. My research shows that for raw execution time they are
about the same in response times; however, Nginx has a far smaller memory
footprint and blows the doors off of Apache with static file delivery.
