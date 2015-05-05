---
layout: post
title: "Using curl against an API"
date: 2015-05-04 21:30:37 -0500
comments: true
categories: 
- Linux
---
Sometimes you need to make a quick call against an api but may not have the
willpower or time to crack open a script to get things done...  When those
moments hit just fall back on curl!

<!-- more -->

Send a json document to an API with basic authentication:

```bash
curl -H "Content-Type: application/json" \
     -u CLIENT_ID:CLIENT_SECRET \
     -X POST https://api.roflcopters.com/events \
     -d '{"name":"cool event"}'
```

The `-u` followed by the `client_id:client_secret` is what will format the
request for basic authentication.  If the response coming back is pretty long
and/or in json format you may want to check and see if you have `json_pp`
installed.  If you are on Ubuntu this should be in there by default.


```bash
curl -H "Content-Type: application/json" \
     -u CLIENT_ID:CLIENT_SECRET \
     -X POST https://api.roflcopters.com/events \
     -d '{"name":"cool event"}' | json_pp

# Should output in a nice format like this
#{
#   "created_at" : 2938420,
#   "updated_at" : 2938420,
#   "id" : 1,
#   "name" : "cool event"
#}
```

If you have an Oauth2 token and your curl supports it you can use
`--oauth2-bearer` to set the header, this is a little different than the `-u`
header that is created for basic authentication.

```bash
curl --oauth2-bearer="aBunch0fgarble" \
     -H "Content-Type: application/json" \
     -X POST https://api.roflcopters.com/events \
     -d '{"name":"cool event"}' | json_pp
```

Also, you if need to send post data the _"normal"_ way you can leave off the
`-H` header with content type and format your data with the
`application/x-www-form-urlencoded` format:

```bash
curl -u CLIENT_ID:CLIENT_SECRET \
     -X POST https://api.roflcopters.com/events \
     -d 'name=cool event'
```
