---
layout: post
title: "Formatting JSON with jq"
date: 2015-11-10 18:02:57 -0600
comments: true
categories: 
- Linux
---
If you haven't tried it out yet, I **highly** recommend checking out the
application [jq](https://stedolan.github.io/jq/).  It allows you to quickly
format json with bash or any other light weight scripting languages.  I've been
playing around with this for about a week and I would like to share some of the
features it has.

<!-- more -->

### --sort-keys

If you work with a service like ElasticSearch where the keys are never in the
same order this is an amazing feature.  I have used it with `vimdiff` to wire up
some quick diffs.  This example grabs two different documents from ElasticSearch
and shows a side-by-side difference of the two documents.  Note how it drills
strait down into the `._source` key, which is the data we care about.

``` bash
curl -s -XGET localhost:9200/items/item/1 | jq --sort-keys '._source' > left
curl -s -XGET localhost:9200/items/item/2 | jq --sort-keys '._source' > right
vimdiff left right
```

### variables with the dollar sign

Sometimes what you are trying to extract out is pretty far down.  For instance
say you are using a pretty wordy hypermedia API that has the users in the
structure separate from the comments.

``` json
{
  "url": "http://nobody.cares.com/post/6/comments.json",
  "data": {
    "comments": [
      {
        "id": 483,
        "post_id":6,
        "user_id":6,
        "message":"Get to the chopper!"
      },
      {
        "id": 487,
        "post_id":6,
        "user_id":5,
        "message":"Life is like a box of chocolates..."
      },
      {
        "id": 489,
        "post_id":6,
        "user_id":6,
        "message":"Come with me if you want to live"
      }
    ]
  },
  "extra": {
    "users": {
      "url": "http://again.nobody.cares.com/users",
      "read_only": true,
      "data": [
        {
          "id": 6,
          "name": "Arnold"
        },
        {
          "id":5,
          "name": "Forest"
        }
      ]
    }
  }
}
```

The following will combine the user with the comment

``` bash
jq '[
  .extra.users.data as $users |
  .data.comments[] |
  . as $comment |
  $comment + {user: ($users | map(select(.id == $comment.user_id))|first)} |
  del(.user_id)
  ]'
```

And produce the following output:

``` json
[
  {
    "id": 483,
    "post_id": 6,
    "message": "Get to the chopper!",
    "user": {
      "id": 6,
      "name": "Arnold"
    }
  },
  {
    "id": 487,
    "post_id": 6,
    "message": "Life is like a box of chocolates...",
    "user": {
      "id": 5,
      "name": "Forest"
    }
  },
  {
    "id": 489,
    "post_id": 6,
    "message": "Come with me if you want to live",
    "user": {
      "id": 6,
      "name": "Arnold"
    }
  }
]
```

## --raw-output

Being able to manipulate json into an easily digestible format for scripts gets
even better. Using the same example from above:

``` bash
jq --raw-output '.extra.users.data[] | (.id | tostring) + ":" + .name'
```

Produces the following output

```
6:Arnold
5:Forest
```

There is a **ton** of features baked into this and I have only scratched the
surface.  As I run into uses for them I plan to put together a sticky page of
recipes I have used.  Stay tuned!
