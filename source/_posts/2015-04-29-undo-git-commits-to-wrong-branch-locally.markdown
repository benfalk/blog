---
layout: post
title: "Undo Git Commits to Wrong Branch Locally"
date: 2015-04-29 20:12:27 -0500
comments: true
categories: 
- Git
---
Ever thought you have started commiting work to a new branch and realized your
still working off of the wrong branch?  Up until today I would normally rewind
my commit(s), then switch to the branch I should have had and re-commit my work.
It turns out this whole time I could have been doing this...

```bash
git branch -m the-branch-i-should-have-been-on
```

This in no way harms the branch you where on as it will just pull down the
remote again that you were on originally on!  Meaning the following chain of
commands will work out just fine...

```bash
# on master when I thought I was on feature-x
git commit -m "Feature X was added because we needed more magic"

# Ahhhh crap, I'm on master!
git branch -m feature-x
git push origin feature-x
git checkout master # it's master from before I commited Feature X!
```

Shout out to [Nola](https://github.com/rubygeek) for showing me this.
