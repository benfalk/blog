---
layout: post
title: "Splat Operator in Case Statement"
date: 2015-01-13 20:46:33 -0600
comments: true
categories: 
- Ruby
---
Today I learned that this is valid ruby and is yet another example of how
awesome the splat operator, `*`, really is.

```ruby

  EVENS = [0,2,4,6,8]
  ODDS  = [1,3,5,7,9]
  
  result =
    case 3
    when *EVENS
      :even
    when *ODDS
      :odds
    else
      :unkown
    end

  result # => :odds

```
