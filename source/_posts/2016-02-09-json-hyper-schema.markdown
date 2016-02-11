---
layout: post
title: "JSON Hyper-Schema"
date: 2016-02-09 16:57:56 -0600
comments: true
categories: 
- API
- Development
---
Last week we looked at [JSON Schema](/blog/2016/02/02/json-schema-for-your-api/)
and how it can be used it in describing the data of your API.  In this post
we'll be looking at the `JSON Hyper-schema`.  It is a schema built on top of the
`JSON Schema` and describes the URLs that can be built with a given resource.
Let's look at how we can use this spec to help supplement our APIs. 

<!-- more -->

Like last time, let's work with an example.  Here is the schema similar to the
one from the last post:

```json
{
  "id":"http://benfalk.com/person.json",
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"Person",
  "description":"A simple data model of a social human being",
  "type":"object",
  "required":[ "first_name", "last_name", "birthdate" ],
  "properties":{
    "id": { "type":"string" },
    "first_name":{ "type":"string", "minLength":1 },
    "last_name":{ "type":"string", "minLength":1 },
    "birthdate":{ "type":"string", "format":"date-time" },
    "friends":{ "type":"array", "items":{ "$ref":"#/" } }
  }
}
```

Here is how we can enrich this with the hyper-schema spec.  With this schema we
have defined how to update the data, where to get the friends list, how to add a
friend, and lastly how to delete the person.

```json
{
  "id":"http://benfalk.com/person.json",
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"Person",
  "description":"A simple data model of a social human being",
  "type":"object",
  "required":[ "id", "first_name", "last_name", "birthdate" ],
  "properties":{
    "id":{ "type":"string" },
    "first_name":{ "type":"string", "minLength":1 },
    "last_name":{ "type":"string", "minLength":1 },
    "birthdate":{ "type":"string", "format":"date-time" },
    "friends":{ "type":"array", "items":{ "$ref":"#/" } }
  },
  "links":[
    {
      "title":"Update the person",
      "rel":"update",
      "href":"/people/{id}",
      "method":"PUT",
      "schema":{
        "type":"object",
        "properties":{
          "first_name":{ "type":"string", "minLength":1 },
          "last_name":{ "type":"string", "minLength":1 },
          "birthdate":{ "type":"string", "format":"date-time" }
        }
      }
    },
    {
      "title":"Get friends list",
      "rel":"friends",
      "href":"/people/{id}/friends"
    },
    {
      "title":"Add a friend",
      "rel":"add-friend",
      "href":"/people/{id}/friends",
      "method":"POST",
      "schema":{
        "type":"object",
        "properties":{
          "id":{ "type":"string" }
        },
        "required":["id"]
      }
    },
    {
      "title":"Delete person",
      "rel":"delete",
      "href":"/people/{id}",
      "method":"DELETE"
    }
  ]
}
```

This is a great way to describe to clients how it can interact with your API in
a way that can be automated.  While a lot of clients still don't use it much you
can use the `Link` header of HTTP to point to these.

```
Link: <http://api.whatever.com/schemas/person.json>; rel="describes"
```

I like to think of this as "CSS for your API".  It describes to the client how
it can style the data with links to more resources.  Not many clients understand
this yet; however, with companies like GitHub using it for things like
pagination it feels like adoption will only get better as time goes by.

The `JSON Hyper-Schema` is very extensive and we've only covered a small part of
it.  It also makes provisions for media-types and URI validations.  If you want
to read more in depth on the subject I recommend heading on over to the
[json-schema.org](http://json-schema.org) and reading up more on it.
