---
layout: post
title: "Better Ruby Hash Handling"
date: 2015-10-08 20:14:10 -0500
comments: true
categories: 
- Ruby
---
You'll be hard pressed to escape working with hashes in Ruby, but don't make
using them a painful experience.  Here are some helpful tips that I've collected
that I would like to share.

<!-- more -->

## slice over a helper method

I see this more often then I care to remember:

``` ruby
  def convert(hash)
    {
      key: hash[:key],
      key2: hash[:key2]
    }
  end
```

Hash has this built in and performs the same as above.

``` ruby
hash.slice(:key, :key2)
```

## churning values out into an array

``` ruby
  [hash[:key], hash[:key2], hash[:key3]]
```

`values_at` will perform this with a little less mess.

``` ruby
  hash.keys(:key, :key2, :key3)
```

## merge can be a big help

``` ruby
  def convert(hash)
    {
      somekey: hash[:somekey],
      another: another
    }
  end
```

Instead, maybe this:

``` ruby
  hash.slice(:somekey).merge(another: another)
```
