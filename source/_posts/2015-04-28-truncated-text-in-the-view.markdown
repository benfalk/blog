---
layout: post
title: "Truncated Text in the View"
date: 2015-04-28 20:14:34 -0500
comments: true
categories: 
- Software Process
- Website Architecture
---
If you've been in web development for any amount of time, eventually you'll run
into the challenge of shortening the amount of text that is on your website.
This will apply for certain areas on your pages.  No matter what your software
stack is, it seems like the first area to tackle truncating text is on the
back-end.  I would urge everyone to strongly reconsider doing this server side
because most of the time it is a client-side view's concern and I'll explain
why...

<!-- more -->

Normally the text truncation comes when it doesn't fit in a view that has been
designed to be "pixel perfect".

{% img /images/text-truncation-at-work.png "The pixels are prefect!" %}

The above example clearly has some tight requirements as to how much text can be
shown to keep these intros in the containing boxes.  This could be calculated on
the back end fairly well and sent on to the web page as such; however, this
removes a lot of flexibility.  Let's take a look at the exact same news feed
from a mobile view.

{% img /images/moar-truncation-such-wow.png "Behold, pixels are still stable %}

It seems even more text is truncated for this view; which makes sense.  If you
were to truncate on the server side it would become a fools errand to try and
send any number of combinations of truncated text for each kind of view.

This problem becomes even more compounded when you begin to factor in the
different kinds of font-faces you use and how they are rendered on different
kinds of devices.  It seems pretty clear this is a view concern; and not only a
view concern, but one that should be handled client side with some css and
javascript trickery.

I'm not saying to never, ever truncate data server side.  What I am saying is do
not truncate the data for these kinds of view requirements server side.  It will
end up not looking good for many different clients.  Instead, pick a sensible
big chunk of intro text and stick with that.  It never seems to hurt sending too
much over too little.
