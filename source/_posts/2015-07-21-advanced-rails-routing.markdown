---
layout: post
title: "Advanced Rails Routing Constraints"
date: 2015-07-21 09:15:31 -0500
comments: true
categories: 
- Ruby
- Rails
---
One of the parts of the Rail's stack that always seemed to confuse me was the
routing.  Once you go beyond the simple `resource` routing unless you have a bit
more under you're belt reading and writing routes can be daunting.  I would like
to go over just a couple items that I've picked up which may prove helpful for
others who need to go beyond the vanilla route schemes.

<!-- more -->

If you dig into some of the more recent routing documents for Rails you'll find
some examples using `scope` to namespace routes; however there is more you can
do with it then I've found in the docs.  Scope applies a matching rule and will
allow any matches to trickle down into it's block for further matching.

For instance, if you have to make an advanced routing decision based on
something in the request besides the just the http verb and the uri, you can use
the `contraints` key. The following route will match `/motd` and route it to the
`BotsController#motd` only if the request headers' user agent has `curl` in it.

``` ruby
  get '/motd',
      to: 'bots#motd',
      constraints: ->(request){ /curl/ =~ request.headers['HTTP_USER_AGENT'] }
```

A pretty contrived example; however, it helps to put some of these decisions in
the router instead of forking totally different kinds of logic in the
controller.  If you have a lot more routes like this that you would like to map
to the the `BotsController` you can use scope to do it.

``` ruby
  scope constraints: ->(request){ /curl/ =~ request.headers['HTTP_USER_AGENT'] } do
    get '/motd', to: 'bots#motd'
    get '/uptime, to: 'bots#uptime'
  end
```

If your logic starts to get a little hairy, or you just want ot keep everything
tidy, you can also pass `constraints` an object that has a `matches?` method for
the request.

``` ruby
  class BotsConstraint
    def matches?(request)
      /curl/ =~ request.headers['HTTP_USER_AGENT']
    end
  end
```

Used in the routes:

``` ruby
  scope constraints: BotsConstraint.new
    get '/motd', to: 'bots#motd'
    get '/uptime, to: 'bots#uptime'
  end
```
