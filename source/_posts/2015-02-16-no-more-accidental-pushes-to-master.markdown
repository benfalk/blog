---
layout: post
title: "No More Accidental Pushes to Master"
date: 2015-02-16 15:54:20 -0600
comments: true
categories: 
- Development
- Git
---
If you're like me; sometimes you'll get cranking on some code and before you
realize it, you push your changes back up with the help of tab completion
auto-populating your branch for you... which was master.  You quickly realize
the pain you're in as all kinds of amazing build processes kick off with the
ceremonious event of a new master build!  After doing this twice in a year I
decided to find a way to help prevent myself from doing it again.

<!-- more -->

To take advantage of this you'll need **git at version 1.8.2** or higher as it
uses a `pre-push` hook.

First things first.  If you haven't yet you'll want to set up your own template
directory to use with git.  From your terminal run the following commands:

``` bash
mkdir -p ~/.git_template/hooks
git config --global init.templatedir '~/.git_template'
```

Create a `pre-push` hook like this (make sure it's set to executable)
``` bash ~/.git_template/hooks/pre-push
#!/bin/bash

protected_branch='master'  
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $protected_branch = $current_branch ]  
then  
    read -p "You're about to push master, is that what you intended? [y|n] " -n 1 -r < /dev/tty
    echo
    if echo $REPLY | grep -E '^[Yy]$' > /dev/null
    then
        exit 0 # push will execute
    fi
    exit 1 # push will not execute
else  
    exit 0 # push will execute
fi  
```

This creates a directory and tells git that any repository initialized should
pull in these files as part of the `.git` structure.  This means you won't have
to worry about adding the `pre-push` hook to any future git repos you clone.
For any existing repos doing a simple `git init` should pull in the changes you
want.

The `pre-push` hook checks if the branch you are working from is master and will
warn you about your attempt to push to master.  This forces you to stop and
think about it before answering with a `Y` if that is truely want you want to
do.
