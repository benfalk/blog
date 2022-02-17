---
layout: post
title: "My Current NeoVim Setup"
date: 2022-02-15 00:19:56 +0000
comments: true
categories:
- Development
- Vim
---

It's been almost six years since switching over to NeoVim, and every so often I
find myself showing off my current setup to other Vim / NeoVim users to give
them an idea of what is possible with it.  This post will be a quick list of
recommended plugins and other tidbits you may want to incorporate in your setup
as well.

{% img /images/neovim-demo.png "My NeoVim Setup Demo"%}

<!-- more -->

## 1. [Kitty](https://sw.kovidgoyal.net/kitty/)

So it's not anything _directly_ related to NeoVim; however, if you're looking at
that sweet eye-candy and digging it then you'll most likely want the terminal
emulator that works the best with it across every OS.  I rock it on both OSX and
Ubuntu personally and I've heard it works well on Windows as well.  I highly
recommend [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) with it as well
with the patched `Fira Code` font with ligature support.  This is what gives my
icons in the demo picture above in the file explorer, which is NerdTree.

## 2. [Telescope](https://github.com/nvim-telescope/telescope.nvim)

{% img /images/telescope-demo.png "Telescope Demo"%}

This is an incredibly useful plugin that can really replace or augment some of
the plugins you might already have in your tool-belt.  It has a very good
interface that lets plugin makers use it for all kinds of things, from the
simple file fuzzy finder, to text searching capabilities, and even for things
such as searching for all places a reference is located in a project.

## 3. [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

If you've wished that syntax color highlighting was better, then you probably
haven't heard of or used `nvim-treesitter`.  This amazing plugin has a deeper
understanding for code and can give you a richer coloring.  I've noticed with
Ruby it does better then what I've seen with any of the bigger IDEs I see people
using.  The same is true for `C#` and `Rust`.  I highly recommend you try it
with a treesitter compatible color theme.

## 4. [Conquer of Completion](https://github.com/neoclide/coc.nvim)

If you've tried setting up different language servers with NeoVim you know it
can be a pain.  This largely takes away that headache using it's own form of
additional plugins.  If you've ever used VSCode, it is very much like that in my
opinion.  I believe the story for setting up language servers has gotten a lot
easier; however, this is extremely easy-mode so I haven't tried anything else in
almost three years when it comes to autocompletion.
