---
layout: post
title: "JSON Schema For Your API"
date: 2016-02-02 18:20:02 -0600
comments: true
categories: 
- API
- Development
---
It's pretty easy to stand up an API.  Unfortunately sometimes though, this
easiness is a false friend you can be paying for down the road.  Once you get
any amount of consumers; even if they are internal, expressing the data models
your API delivers and how it is validated can be a messy chore.  You may write
up some fancy documents describing your API (which is good); however, this can
lack a bit in the area of tooling.  This is where JSON Schema can really shine.

<!-- more -->

### What is JSON Schema?

The JSON schema is a spec used to describe complex data structures.  Because it
has an official spec behind it, there are quite a few tools out there that you
can use to take advantage of it.  This gives you a way to publish agreed upon
documents that other vendors can use to model the data from your API.

### Simple Example

This schema is simple, but shows off how data can be described.  This models a
person as having a `first_name`, `last_name`, `birthdate`, and optionally
`friends`.  Just glancing at it this all may seem pretty obvious except for
maybe the `friends` part.  The `$ref` is a way in the spec to reference another
part of your schema document.  In this case it references the top level of the
schema which means that `friends` can be an array of `Person` objects.

```json
{
  "id":"http://benfalk.com/person.json",
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"Person",
  "description":"A simple data model of a social human being",
  "type":"object",
  "required":[ "first_name", "last_name", "birthdate" ],
  "properties":{
    "first_name":{ "type":"string", "minLength":1 },
    "last_name":{ "type":"string", "minLength":1 },
    "birthdate":{ "type":"string", "format":"date-time" },
    "friends":{ "type":"array", "items":{ "$ref":"#/" } }
  }
}
```

### More Complex Example

Part of the spec sets aside the key `definitions` as an area where you can
define types so you don't have to repeat them in your schema.  Here is the same
schema from above using that as an example.

```json
{
  "id":"http://benfalk.com/person.json",
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"Person",
  "description":"A simple data model of a social human being",
  "type":"object",
  "required":[ "first_name", "last_name", "birthdate" ],
  "properties":{
    "first_name":{ "$ref":"#/definitions/name_field" },
    "last_name":{ "$ref":"#/definitions/name_field" },
    "birthdate":{ "$ref":"#/definitions/datetime" },
    "friends":{ "type":"array", "items":{ "$ref":"#/" } }
  },
  "definitions":{
    "name_field":{ "type":"string", "minLength":1 },
    "datetime":{ "type":"string", "format":"date-time" }
  }
}
```

### Example Referencing Another Schema

Of course sometimes you'll have a rich set of models which reference each other.
Don't worry, the spec also has a way to reference other documents via _http_.
This new spec expands upon the last one by adding in a `hobbies` key, which
references `/hobby.json#`.  So what is happening here?  The magic is in the
`id`.  When a reference is relative like this the spec says to default to the
host found in the id field to resolve another schema file.  If the uri in the
reference is a fully qualified url then the id is ignored and it will look for
it at the location given.

```json
{
  "id":"http://benfalk.com/person.json",
  "$schema":"http://json-schema.org/draft-04/schema#",
  "title":"Person",
  "description":"A simple data model of a social human being",
  "type":"object",
  "required":[ "first_name", "last_name", "birthdate" ],
  "properties":{
    "first_name":{ "$ref":"#/definitions/name_field" },
    "last_name":{ "$ref":"#/definitions/name_field" },
    "birthdate":{ "$ref":"#/definitions/datetime" },
    "friends":{ "type":"array", "items":{ "$ref":"#/" } },
    "hobbies":{ "type":"array", "items":{ "$ref":"/hobby.json#" } }
  },
  "definitions":{
    "name_field":{ "type":"string", "minLength":1 },
    "datetime":{ "type":"string", "format":"date-time" }
  }
}
```

A couple gotchas here are the spec really only makes way for http and anything
else, such as from disk, are unsupported.  The other gotcha when referencing
documents is there doesn't appear to be a relative location ability built into
the spec.  This means if you start serving your documents under a new
sub-directory you'll have to go through all of your references and update them.

### Wrap Up

If you want to learn more about JSON Schema you can head on over to the official
website at [json-schema.org](http://json-schema.org/).  In my next post I'll
cover some more advanced sections of the spec, including parts which are geared
directly for determining what kind of urls you can build from the data models
you have!
