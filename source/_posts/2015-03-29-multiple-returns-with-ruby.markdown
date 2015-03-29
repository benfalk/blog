---
layout: post
title: "Multiple Returns with Ruby"
date: 2015-03-29 10:16:48 -0500
comments: true
categories: 
- Ruby
---
I've been looking through a fair amount of code lately where the author has
elected to use `return` with multiple values.  For those who haven't seen this
witchery, it looks something like this:

``` ruby
  def left_right(point, pivot)
    return point - pivot, point + pivot
  end
  left_right(6, 4) # => [2, 10]
```

I am not a big fan of this and try to avoid it when I write code.  To me it
hides what is really happening, which is the fact that an array is being
constructed that has heavy importance on the order of each value.  It also
**forces** you to use the `return` keyword, which I prefer not to have at all
when I can avoid it. _(+10 for Erlang not having `return`)_

<!-- more -->

The same method can be rewritten as follows:

``` ruby
  def left_right(point, pivot)
    [point - pivot, point + pivot]
  end
  left_right(6, 4) # => [2, 10]
```

This, to me doesn't feel to much better.  It has to do with the fact we have
created an ad-hoc datum object that will leave future readers slightly puzzled.
After giving it some thought here is what I landed on for a solution I personally
like.

``` ruby
  class PivotPoints < Array
    
    attr_reader :left, :right

    def initialize(point, pivot)
      @left  = point - pivot
      @right = point + pivot
      self[0] = @left
      self[1] = @right
    end
  end
```

"Why did I extend `Array`?", you may ask.  In this case only to be compatible
with why the original multiple return was even a thing to begin with.

``` ruby
  left, right = left_right(6, 4) # => [2, 10]
  left  # => 2
  right # => 10
```

I also recommend avoiding this when you can as well.  This ends my small rant on
multiple returns... I urge everyone to avoid using them and instead realize
there is a new data structure that is begging to be named.
