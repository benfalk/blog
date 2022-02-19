---
layout: post
title: "Elasticsearch Document Size Bloat"
date: 2022-02-18 18:42:57 +0000
comments: true
categories: 
- Elasticsearch
---

I've been working with Elasticsearch off and on in my career and more so on then
off it seems for the last couple years.  It's a great tool to get aggregations
and quick searching on data; however, sometimes you need to be careful or the
size of your documents can get out of hand.

<!-- more -->

To illustrate my point, let's come up with a somewhat believable schema that you
could likely have in your application.

```
Author:                Category:
  id                     id
  name                   tag
  country
  language
                       PostCategory:
Post:                    post_id
  id                     category_id
  title
  content
```

If you wanted posts and related data to be searchable in Elasticsearch your
document structure would likely look like this:

```json
{
  "_id":"the-post-id",
  "_source": {
    "title":"some-title",
    "content":"full text content stuff",
    "author": {
      "id": 42,
      "name": "Ben",
      "country": "United States",
      "language": "English"
    },
    "categories": [
      {
        "id": 13,
        "tag": "json"
      },
      {
        "id": 42,
        "tag": "programming"
      }
    ]
  }
}
```

As you can see, this document is essentially a denormalized data structure of
what you can expect to find in the schema.  It comes with the same benefits and
drawbacks when you denormalize data.  It's fast because you don't have to look
at any other data sources; however, the data contains duplications which
increases space. Every `Post` caries with it an `Author` and any number of
`Category` objects.

If you search by `author.name` there is a good chance you'll have duplicate
authors in each of the posts.  If you fetch N number of documents and all of
them have the same `Author` you're needlessly deserializing N-1 of them.  In
this example that doesn't seem bad, but suppose it was a more complex model...
You're just compounding the number of allocations you'll incur and the size of
the total payload just keeps growing.

If you run into these kinds of scenarios they can be mitigated by using the
`_source` and `fields` directives in your Elasticsearch queries to pair down
the data you need.  There is a lot of nuance with these and it is highly
recommended that you [read the docs](https://www.elastic.co/guide/en/elasticsearch/reference/8.0/search-fields.html)
for yourself. Having said that, what follows are a couple examples you may want
to think about in your application.

### Fetch Primary Keys and Build It Yourself

One strategy may be to fetch only the keys from the document and in a second
parallel manner retrieve the data from cache or the database it came from.

**Request:**
```
GET /_search
{
  "query": {
    "match": {
      "author.name": "Ben"
    }
  },
  "fields": [
    "author.id",
    "categories.id"
  ],
  "_source": false
}
```

**Reply:**
```
{
  "hits" : {
    "total" : {
      "value" : 420,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my-index-000001",
        "_id" : "the-post-id",
        "_score" : 1.0,
        "fields" : {
          "author.id" : [42]
          "categories.id" : [13, 42]
        }
      }
      ... 419 more hits ...
    ]
  }
}
```
_Slight side note; if you noticed the `author.id` field is an array even though
our document has a single author it's because the underlying mappings actually
store these leafs as a list._

This is a tremendous savings on Elasticsearch as it doesn't need to send the
original document and all it needs to do is supply the mappings that matched the
document instead.  The trade-off of course is you now need to wait for the
response from Elasticsearch and then kick off extra potential requests to other
data stores so weigh your application needs accordingly.  Obviously if all you
care about is several fields in your document this is a big win indeed.

### Source filtering to Pair Down Data

A secondary strategy, that you can actually combine with the previous, is to have
Elasticsearch pair down the JSON document it sends to you.

**Request:**
```
GET /_search
{
  "query": {
    "match": {
      "author.name": "Ben"
    }
  },
  "_source": {
    "include": {
      "includes": ["title", "content", "author.name", "categories.tag"],
      "excludes": []
    }
  }
}
```

**Reply:**
```
{
  "hits": {
    [
      {
        "_index" : "my-index-000001",
        "_id" : "the-post-id",
        "_score" : 1.0
        "_source": {
          "title": "some title",
          "content": "some content",
          "author": {
            "name": "Ben"
          },
          "categories": [
            { "tag": "json" },
            { "tag": "programming" }
          ]
        }
      }
    ]
  }
}
```

This prunes the document down to just the fields you'll be using but maintains
the relative structure of it.  You'll still be incurring allocation costs to
deserialize duplicates but at least it only for the data you'll be directly
using.  One giant bullet point to `_source` filtering is it's not free.  By
default Elasticsearch will simply pass the whole document without parsing it at
all; however, source filtering will require Elasticsearch to deserialize the
document to derive the filtered structure.  You'll see a fair amount more memory
being utilized with this so at larger scale and volume of data you'll probably
want to find other optimizations.

## Conclusion

Using Elasticsearch as a document store is pretty descent, but as your data
requirements change and grow it can be easy to simply keep tacking on fields to
your documents.  There are a number of solutions to mitigate how much data you
transfer to avoid large chunks of overhead, and sometimes they come with their
own costs.  Here we covered the two primary ways of filtering data, `fields` and
`_source` filtering.  If at all possible you should reach for `fields` when
possible.
