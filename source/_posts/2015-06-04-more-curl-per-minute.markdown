---
layout: post
title: "More curl per Minute"
date: 2015-06-04 18:05:20 -0500
comments: true
categories: 
- Linux
- Bash
---
Today I had to do some advance `curl`ing and I though I would share what I did
to really get the most out of what I was doing.  Essentially I had a huge CSV of
values that I wanted to go through and get the status header for.  One option
possible was to bust out Ruby or Elixir and write some _quick_ software to
accomplish the task; but bash once again has come out on top with the _one
liner_ that seems to be ideal.

<!-- more -->

To start with, dealing with CSVs can be a pain; however, most times `cut` has
your back.  Lets says you only want the second column of a CSV.  To do that use
the following command...

``` bash
cat file-of-things.csv | cut -d , -f 2
```

This breaks the input of a file with each line using the delimiter of `,` and
takes the second field; denoted with `-f 2`.  If you wanted to grab say the
first and third field it would look like this...

``` bash
cat file-of-things.csv | cut -d , -f 1,3
```

In my case I only wanted the first field; which contains the URLs that I wanted
to check.  Here is the command that was used; which will be broken down:

``` bash
cat file-of-things.csv | cut -d , -f 1 | xargs -n 1 -P 10 -I URL curl -sL -w "%{http_code} %{url_effective}\\n" URL -o /dev/null > results.txt
```

This is taking the urls from the csv, running 10 curls at a time, and outputting
the http status code and url tried to a `results.txt` file.  I don't want to go
into too much detail on the `curl` part of this call but I would like to explain
more on what xargs is doing.  The `-n` part is saying to run each line as an
argument to a command.  The `-P` part is how many items you want to run in
parallel; in our case ten at a time.  The `-I URL` part is taking our single
parameter and substituting anywhere it finds `URL` with the line from the list.

Lastly the output of all of these results are being aggregated into a
`results.txt` file with the following format:

```
200 http://benfalk.com/archives/
404 http://benfalk.com/best-php-ever/
```

If you have what seems like a complicated task; look again.  It may be as simple
as the one liner I found!
