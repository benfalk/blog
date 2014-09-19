---
layout: post
title: "CTags are the bomb"
date: 2014-09-18 20:29:59 -0500
comments: true
categories: 
- Development
- Vim
---
Recently I discovered what may be the best find yet on my path to
enlightenment with vim, [ctags](http://ctags.sourceforge.net/).  This nugget
is amazing!  It works with an impressive list of languages, of which Ruby and
Erlang can be found.  With Ubuntu it can be installed simply with

```bash
sudo apt-get install exuberant-ctags
```

From the working directory of your project the command "ctags -R" will index
all the source files found in your project and put them in a file called
"tags".  For this reason I added "/ctags" to my git global ignore file found
[here](https://github.com/benfalk/dotfiles/blob/master/gitignore_global).  Once
the ctags file is created you can start up vim, and with your cursor under any
language constant you can press "ctrl+]" and will jump to the file:line were
it is defined.
