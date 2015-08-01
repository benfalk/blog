---
layout: post
title: "Avoid Swallowing Errors"
date: 2015-08-01 16:27:29 -0500
comments: true
categories: 
- Ruby
- Development
---
In programming eventually we run into times when the un-expected happens.  These
unfortunate times are when exceptions are raised.  Normally exceptions should be
reserved for exceptional circumstances; however, there are times when exceptions
don't completely break the bank.  In fact, sometimes they are expected and lead
to bigger problems when trying to handle them.

<!-- more -->

Let's look at the following example which attempts to determine if a `uri` is
valid or not.

``` ruby
  def is_valid_uri?(uri)
    URI.parse(uri)
    true
  rescue
    false
  end
```

It turns out that `URI.parse` will raise a `URI::InvalidURIError` if the
argument passed to it is not valid.  This code uses that fact to rescue the
exception and return false for this case.

While I don't personally like this kind of code much to begin with, I can see
where it has a time and place.  Perhaps one of the most serous problems with
this is other things can go wrong that would go unseen.  Let's assume that
`URI.parse` attempts to cast it's argument as a string before parsing it.  And
then lets assume we have a model that fits into that with some lazy loading.

``` ruby
  model DB::URI
    attr_accessor :id
    def to_s
      uri_from_db(id)
    end
    # ... other logic
  end
```

We now have an opportunity for our database connection to fail, and instead of
halting our program with a database exception `is_valid_uri?` will instead
return false.  This is the biggest danger of swallowing errors, but luckily you
can be a little bit more cautious.  Instead of just blindly rescuing exceptions,
rescue only what you expect.

``` ruby
  def is_valid_uri?(uri)
    URI.parse(uri)
    true
  rescue URI::InvalidURIError
    false
  end
```

It may not seem like much; but trust me, it can save you hours of debugging
code!
