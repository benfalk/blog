---
layout: post
title: "Ruby Inheritance with Super"
date: 2015-06-07 17:59:57 -0500
comments: true
categories: 
- Ruby
---
A couple days ago during a code review one of my coworkers noticed that we
called the `super` method with no parameters and still had parenthesis.  They
wanted to remove it; however, it turns out in Ruby that `super` does some extra
magic that you need to be careful about.

<!-- more -->

To begin we need to talk about class inheritance; a concept _most_ if not all
object oriented based languages use.  Let's look at some Ruby code and explore
this concept.

``` ruby
class Widget
  attr_reader :id, :name

  def initialize(id='', name='')
    @id = id
    @name = name
  end
end

class Sprocket < Widget
  attr_reader :type

  def initialize(*_args)
    super
    @type = name[/t-(\d*)/, 1]
  end
end
```

When the `Sprocket` class re-defines the `initialize` method, you can use
`super` to call the parent class method.  With Ruby; however, super acts a
little different than other method calls.  When you use a _"naked"_ call to
super like in the code example above on line 14, it gets passed all of the
parameters that the child method receives.

For this reason, if you want to override the default functionality you have to
call `super()` so Ruby knows not to pass all of the parameters down to the
parent class method.  This doesn't happen to often, but when it does it can
catch you by surprise.

Another thing I discovered when playing around with `super` for this post is you
shouldn't name a method this:

``` ruby
class Thing
  def yell
    "heyyy!"
  end

  def super
    "super sweet"
  end
end

class ThingABobber < Thing
  def yell
    super + '!!!'
  end

  def icecream
    super + ' icecream!'
  end

  def lollipop
    self.super + ' lollipop'
  end

  def candy
    send(:super) + ' candy'
  end
end

ThingABobber.new.yell # => "heyyy!!!!"
Thing.new.super # => "super sweet"
ThingABobber.new.icecream # => NoMethodError: super: no superclass method 'icecream'
ThingABobber.new.lollipop # => "super sweet lollipop"
ThingABobber.new.candy # => "super sweet candy"
```

It turns out `super` not bound to an object tries to call a higher inherited
method.  However; if you use `self.super` or try sending it with `send(:super)`
it will call the method defined as `super`.  I would *highly* recommend naming a
method super, but, it does look like it won't mess up how it works if you take
extreme care.
