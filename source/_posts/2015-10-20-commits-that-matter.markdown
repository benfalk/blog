---
layout: post
title: "Commits That Matter"
date: 2015-10-20 15:48:21 -0500
comments: true
categories: 
- Software Process
---
{% img right /images/bad-commit-messages.jpeg 250 250 "Bad commit Messages"%}

Work in software long enough and you'll eventually need to do some serious
digging into the code base to try and figure out _why_ code was done a certain
way.  Commit messages can be a great tool when digging up the past to uncover
these mysteries.  Please don't be **that person** who makes understanding the
past harder. There a two main classes that I believe hinder this; pointless
commits and useless commit messages.  The following examples are a breakdown of
such offenses.

<!-- more -->

# Pointless Commits

When a commit has little to no value by itself I consider it pointless. These
serve only to add noise which you have to sift through to obtain anything
meaningful.  Here are some examples:

### The Old "One-Two"

```
* Add Feature XYZ
* Fix Failing Tests for XYZ
```

```
* Add Feature XYZ
* Make variable names more clear
```

These are a time honored classic.  Back-to-back commits that are really the same
thing.  What you'll normally find is the initial addition of a feature or
change.  Then, after user or automated feedback, more code is written based on
that feedback.  To prevent these with git, squash the commits together.  If the
feedback and change are important then document it in the commit message.

### Look What I Did

```
* Clean up whitespace
* Add class X
* Update dependency listing
* Refactor class Y for X
```
This is similar to the _old one-two_ with regards to multiple commits all
belonging to a single change.  When looking back at git history I couldn't care
less that you've cleaned up whitespace or how many times a dependency has
been updated.  Again, squash these commits together and unify the commit
message.

```
* Refactor & Improve Performance for XYZ

  A massive improvement in dependency foo yields a reduction in memory
  consumption by about 20%.

  Removed extra new-lines to conform with our style-guide (foo.bar/style-guide)

  The complexity of class Y was making it hard to understand.  This adds a
  helper class X which seperates a big part of ....
```

# Useless Commit Messages

Bad commit messages often leave use asking _"why"_ and _"what for"_.  If you're
looking back through git history you probably don't care **what** was done, but
instead **why** it was done.

### See Diff for Similar Message

```
* Change Rate Limit from 4 to 12

  - sleep 0.1 while rate > 4
  + sleep 0.1 while rate > 12
```

Thank goodness the diff has been duplicated for my reading pleasure.  This may
seem obvious; but in case it isn't, one can deduce what has changed by looking
at the diff patches.  I'll stress it again, **why**!  I understand sometimes the
reason is trivial; however, more often then not it's only trivial to you right
now in the context you have.  Poor future developer, which could be you, will be
lost as hell when debugging why a changed happened?

### Sorry Developer, Your Answer lays in a different system

```
* Jira Bug #3984037832
```

```
* Address High Connection Problem
  
  http://widgets.inc/wiki/high-connection-issues
```

Ah yes, these take me back to my rpg questing days.  Traveling from place to
place to find answers is a pain.  Not to mention you better pray to god that
the source you've cited stays around longer then your code repository.  Don't
get me wrong, having these as a supplement is fantastic, but they're just that,
a supplement.  A general summery of the cited information goes a long way, do
it!

### A Message is Required to Commit

```
* Hopefully this works
* One last time
* Unbreak the build
* Code Edits
* lksdflsldk
```

Unlike the diff, these provide zero benefit.  These kind of messages appear to
be the result of someone begrudgingly typing as little as possible just to
satisfy the fact git by default requires it.  Replace all of these with _"I'd
rather not say"_ and it feels about the same.  Please take the time and be
courteous to others; fashion an informative message.

# A Recipe for Success

Here is the template I try to use:

```
Present Tense Summary of Code Change

One or two paragraphs explaining what was tried and why
the changes I've made where needed.  Maybe even some 
links to resources where more information can be found.
The main thing to think about is **why**.  Pretend you
will need to look at this in 20 years to answer that
question, it will help.
```
