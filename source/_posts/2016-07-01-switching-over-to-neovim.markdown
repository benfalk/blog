---
layout: post
title: "Switching over to NeoVim"
date: 2016-07-01 16:10:05 -0500
comments: true
categories:
- Vim
---
I've been using vim for coming up on four years now.  It's been an amazing ride
so far and it's impossible for me to imagine not using it anymore.  This fear is
what has kept me from exploring NeoVim until recently, and now I wish I would
have looked into it perhaps a little sooner!  In this post I'll explain how I
moved over to NeoVim and highlight some of the "gotchas" I've found so far.

<!-- more -->

### Taking the Journey

Some simple Google'ing and you'll find a quick little strategy to move from Vim
over to NeoVim via creating the new standard config directory and copying your
`vimrc` file over to the new `init.vim` format.  While that _may_ work I took
this opportunity to take a hard look at the tools I was using and instead elected
to start with a blank slate.

Every plugin I had been using went through a simple checklist to determine **if**
and **how** it was ported over.

1. Am I still using this?  Surprisingly quite a few fell in the `no` camp
   with this and I flat out just didn't bring them over.
2. Is there a NeoVim specific version?  With all of the improvements that
   have been baked into it, plugins that are written explicitly for it will
   probably get some greater mileage.
3. Does it work the same as before?  For `almost` all of these the answer is
   yes; however, I did run into one that had to get the boot: `Powerline`.

### Notable Changes

#### YouCompleteMe

I was using the popular `YouCompleteMe`; however, with NeoVim there is a better
option which takes advantage of it's asynchronous architecture:
[deoplete](https://github.com/Shougo/deoplete.nvim).  I was bit taken back at
first when the `TAB` key didn't cycle through the complete options; however,
with a bit of help from a member in the community I was back on track pretty
quickly.  Here is the solution to get your tab key to select auto-complete
options:

**In your init.vim**
```
inoremap <silent> <expr> <Tab> utils#tabComplete()
```

**nvim/autoload/utils.vim**
```
function! g:utils#tabComplete() abort
  let l:col = col('.') -1

  if pumvisible()
    return "\<C-n>"
  else
    if !l:col || getline('.')[l:col - 1] !~# '\k'
      return "\<TAB>"
    else
      return "\<C-n>"
    endif
  endif
endfunction
```

#### Powerline

Powerline just wasn't working.  I switched over to `vim-airline` and was pretty
pleased with how much it looked and functions - so no complaints there.


#### Vundle

Switched away from Vundle for Plug.  Like `deoplete`, it takes advantage of 
the asynchronous capabilities of NeoVim and can install a full range of plugins
pretty quickly.
