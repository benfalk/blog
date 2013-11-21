---
layout: post
title: "Las Vegas Ruby Users Group"
date: 2013-11-21 08:47:45 -0800
comments: true
categories: 
- LVRUG
---
Last night I went to my second [Las Vegas Ruby Users Group](http://topics.lvrug.org/)
meetup with my wife and really enjoyed it.  One of the dudes talked on the topic
of Hypermedia APIs.  That discussion could be distilled down to the idea that it
is structured like any other API, but, with an emphasis on providing meta data
in the payload on where it and related data can be found.

``` json Example JSON Data Payload mark:8-13
{
  "posts":[
    {
      "id": 7,
      "title": "Example Title",
      "content": "Ever post has content right?",
      "categories": [ "Example", "Test" ],
      "links":[
        { "rel":"author", "href":"/author/6" },
        { "rel":"comments", "href":"/posts/7/comments" },
        { "rel":"self", "href":"/posts/7" },
        { "rel":"posts", "href":"/posts" },
        { "rel":"categories", "href":"/categories" }
      ]
    }
  ]
}
```

A quick example of this was given in rails with a GEM that may turn into my
favorite json building tool [ROAR](https://github.com/apotonick/roar). I plan
on testing it out more to see how I like it.
