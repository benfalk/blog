---
layout: post
title: "Have You Found Your File?"
date: 2014-10-03 06:49:50 -0500
comments: true
categories: 
- Linux
---
When I need to find a file it's normally when I am in Vim and I'll happly use
[Ctrl P](https://github.com/kien/ctrlp.vim).  However, there are tasks outside
of Vim that require my attention daily and I have found the following tips and
tricks to listing and finding files very usefull.

<!-- more -->

Of course, everyone knows what `ls` is, for those who don't we'll take a moment
to weep for their souls... `ls` has more power to it than you may know.  For
instance, if you use `ls -t` it provides a list of files ordered by most
recently modified.

```bash
$ ls -t | head
2014-10-03-have-you-found-your-file.markdown
2014-09-30-raise-in-ruby-is-just-a-method.markdown
2014-09-28-testing-against-multiple-rails-versions.markdown
2014-09-27-visiting-south-cumberland-state-park.markdown
2014-09-20-password-required-gem.markdown
2014-09-21-love-visiting-the-farm.markdown
2014-09-23-bash-tips-and-tricks.markdown
2014-09-18-ctags-are-the-bomb.markdown
2014-09-16-fast-active-record-setup.markdown
2014-03-19-mumble-bot-with-ruby.markdown
```

The real powerhouse of file finding is aptly named `find`.  If you do any kind
of command line work this is a command you should know how to harness the power
of.  My favorite of these is the `-name` option, which matches files like bash
would.

```bash
$ find -name '*.markdown' | sort
./CHANGELOG.markdown
./README.markdown
./source/_posts/2013-11-20-let-me-start-this-up.markdown
# ...

```
Want a ls version of that find?  No problem dude

```bash
$ find -name '*.markdown' -ls | sort -k 11
3805915    4 -rw-r--r--   1 bfalk    bfalk        1303 Mar  7  2014 ./CHANGELOG.markdown
3805918    4 -rw-r--r--   1 bfalk    bfalk        2901 Mar  7  2014 ./README.markdown
4856703    4 -rw-r--r--   1 bfalk    bfalk         388 Mar  7  2014 ./source/_posts/2013-11-20-let-me-start-this-up.markdown
4856704    4 -rw-r--r--   1 bfalk    bfalk        1203 Mar  7  2014 ./source/_posts/2013-11-21-las-vegas-ruby-users-group.markdown
4856705    4 -rw-r--r--   1 bfalk    bfalk        1232 Mar  7  2014 ./source/_posts/2013-11-22-image-scraping-my-wedding-photos.markdown
# ...

```

`sort` is also a powerful ally for just about everything command, in this case
the `sort -k 11` is sorting the 11th column, which is the default of ls, but
you could very easily sort by any other column.

Other noteble features of find

* `-mtime` - Find files edited before or after a certain time, for instance
  `-mtime -2` would list all files edited in the last two days while
  `-mtime +2` would list all files that haven't been edited in the last two
  days
* `-newer <file>` finds all files more recently modified than `<file>`
* `-exec` run a command against each file, for instance
  `find -name '*.rb' -exec flog {} \;` will run `flog` for every ruby file

There are a ton more uses for `find` but these are the ones I use on a daily
basis.  I suggest trying them out and crack open the man pages to discover new
features you might find useful!
