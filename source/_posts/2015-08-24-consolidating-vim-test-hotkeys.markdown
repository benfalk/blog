---
layout: post
title: "Consolidating Vim Test Hotkeys"
date: 2015-08-24 19:01:32 -0500
comments: true
categories: 
- Vim
---
I'm sure most power developers have their tests bound to hot-keys in their
favorite IDE, and having them in Vim is no different.  I fell in love with the
[vim-rspec](https://github.com/thoughtbot/vim-rspec) that Thoughtbot put out.
It has served me well over the years and has saved me countless hours in running
tests by allowing me to run them from a few short key strokes.  Times have moved
on however; and I needed a way to run tests in other languages.

<!-- more -->

When I got more into Erlang I cloned the closet Vim plugin project I could find
that worked like `vim-rspec` and mapped them to `<leader>es`, `<leader>et`, etc.
The idea was they where a near one-to-one clone of the `vim-rspec` plugin keys I
had setup, where a simple `<leader>s`, `<leader>t`, and so on.  This went okay
for awhile until I added Elixir to the mix.  I then had yet another set of key
strokes to remember!

Worst of all, in my head the `vim-rpsec` key-bindings would always overpower the
other language key-bindings.  Thats when I said enough is enough!  I did some
reading and wrote some of my own Vim script to move all of my tests to the same
keystrokes.  I was able to do this using `filetype` in my script.  Here it is in
it's entirety:

``` vim
" Test Suite Mappings
map <Leader>t :call TestCurrentFile()<CR>
map <Leader>s :call TestNearest()<CR>
map <Leader>l :call RunLastTest()<CR>
map <Leader>a :call TestAll()<CR>

function! TestCurrentFile()
  if &filetype=="ruby"
    execute ":call RunCurrentSpecFile()"
  elseif &filetype=="erlang"
    execute ":call EunitCurrentFile()"
  elseif &filetype=="elixir"
    execute ":ExTestRunFile"
  else
    echoe "Unkown filetype to test [".&filetype."]"
  end
endfunction

function! TestNearest()
  if &filetype=="ruby"
    execute ":call RunNearestSpec()"
  elseif &filetype=="erlang"
    execute ":call EunitNearestTest()"
  elseif &filetype=="elixir"
    execute ":ExTestRunTest"
  else
    echoe "Unkown filetype to test [".&filetype."]"
  end
endfunction

function! RunLastTest()
  if &filetype=="ruby"
    execute ":call RunLastSpec()"
  elseif &filetype=="erlang"
    execute ":call EunitLastCommand()"
  elseif &filetype=="elixir"
    execute ":ExTestRunLast"
  else
    echoe "Unkown filetype to test [".&filetype."]"
  end
endfunction

function! TestAll()
  if &filetype=="ruby"
    execute ":call RunAllSpecs()"
  elseif &filetype=="erlang"
    execute ":call EunitTestAll()"
  elseif &filetype=="elixir"
    execute ":!mix test"
  else
    echoe "Unkown filetype to test [".&filetype."]"
  end
endfunction
```

This has me a little more excited to learn some more Vim script and automate
more of tedious daily work away!
