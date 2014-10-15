---
layout: post
title: "Process: Thou Art a Cruel Mistress"
date: 2014-10-14 19:03:52 -0500
comments: true
categories: 
- Miscellaneous
---
> Those who give up automated process for ease of development deserve neither.
>
> -- Benjamin Falk

Oh how I love to hate process.  It's put in place to make things simple, but
when it's heavily reliant on people just doing the right things it sucks.  All
to often it's ritual is used to haze new hires and harnessed as a tool to slow
unwanted changes down by other entities in an organization.

<!-- more -->

Don't get me wrong, I don't think process should leave, but I do believe it
needs to be automated and documented centrally as much as possible.  This
prevents people from making as many mistakes and gives new employees a static
source of truth for how things are done.

Let me run through an example and we'll see how familiar this sounds:

> Hey Peter, saw you created a pull request but didn't reference the ticket
> number from our bug tracker software.  It's no big deal, but this was very
> confusing for QA... Next time create your pull request with the issue number
> in this format "bla-bla-bla_issuexxx"
>
> -- Jared, Project Manager @ Widgets Inc.

Poor Peter the dumb-ass, if only he knew there was process in place to reference
pull requests to the bug tracking software by naming the pull request a certain
way.  In fairness Peter could have asked ahead of time to ensure he was doing
the correct thing, but lets explore another possibility where automated process
could have helped out Peter.

Imagine that shortly after creating his pull request, Peter gets an automated
email letting him know his pull request was automatically closed because it
didn't follow the company's process convention.  The email then linked Peter to
the process best practices which describes how the whole end to end of a pull
request works at Widgets Inc.  After a little self-education Peter could then
rename his pull request and move on.

There are loads of benefits to this small shift.  First, Peter is alerted
immediately about the process he has broken.  Second it has prevented other
teams from being harmed by Peter's mistake, by automatically closing the pull
request.  Third it has referenced where the process documentation is for this
particular thing.  All of these are great, and could be easily implemented by
most software shops of the size that warrant such process to begin with.

I urge everyone, the next time you or one of your fellow work mates breaks
process, run though a small checklist of items that could help prevent
and educate future infractions of said process.  I have a dream brothers and
sisters, I have a dream.
