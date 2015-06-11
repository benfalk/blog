---
layout: post
title: "Who can Predict the Future?"
date: 2015-06-10 21:51:26 -0500
comments: true
categories: 
- Software Process
---
{% img /images/you-think-you-know-but-do-you.jpg %}

One of the most tempting; but often the most dangerous things we do as software
developers is predict our software will change in a specific way.  Always stop
and challenge any extra code you create.  Are you writing this to solve the
problem you have today?  Are you writing this to solve the problem you _may_
have in the future?

<!-- more -->

Develop software long enough, normally not to long, and you will find yourself
regretting not having put in more support for feature x.  This sometimes is a
painful experience, and you're left never wanting to be in that place again.
It's hard to believe, but don't let this trick you into thinking you'll be able
to completely future-proof the code you write.

In fact, writing extra code in an effort to make your project _ultra extendible_
right out of the gate will introduce new pains.  Code written this way; without
fully understanding you're problem domain, tends to corner you into making your
predictions come true when they may not have needed to.  Even worse is when your
crystal ball was wrong and you've made it even harder to move forward on what
really becomes needed.

This doesn't mean we have a free pass to write crap monolithic code of course.
Our goal should be to try and solve our problems with as little code as
possible.  Be diligent in this and always go back to ensure you are solving the
immediate needs your requirements have.  As time goes by you'll begin to
discover where you can leave extendible code in your project.

If you think green-field areas are where this happens, I would tend to say
you're wrong.  Refactoring is one of the best places to really do this.  It's
here where you can get a better handle on how to make the current code, and
future code like it, more malleable.
