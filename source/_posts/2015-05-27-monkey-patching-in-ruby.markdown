---
layout: post
title: "Monkey Patching in Ruby"
date: 2015-05-27 17:38:22 -0500
comments: true
categories: 
- Ruby
---
This week I got into a conversation regarding monkey-patching.  For those
unfamiliar; a `monkey-patch` is when you reopen a class outside of your project
and overwrite or add functionality to it.  To give an example, here is a little
string monkey-patching goodness:

``` ruby
str = "world"

class String
  def excited
    "#{capitalize}!!!"
  end
end

"hello".excited # => "Hello!!!"
str.excited # => "World!!!"
```

By reopening the `String` class and adding an `excited` method to it we are able
to add functionality to one of core classes that ships with Ruby, not to shabby.
Also note that it works for instances of `String` that were created _before_ the
monkey-patch took place.

<!-- more -->

*Warning.* Great care should be exercised when doing this.  Because you are
changing classes that are outside of your control you'll never know when updates
to them could introduce unforeseen bugs.  To help minimize this impact and help
keep your code more modular I suggest using Ruby's `module`:

``` ruby
str = "world" 

module My
  module StringInstanceMethods
    def excited
      "#{capitalize}!!!"
    end
  end
end

# .... another file maybe ... ?

String.include My::StringInstanceMethods

"hello".excited # => "Hello!!!"
str.excited # => "Hello!!!"
```

This has several benefits which will help save you headaches down the road.

*  Because you are including a module you are guaranteeing that the class you
   are patching has been loaded first.  It may not seem like a large problem;
   however, if you are *overwriting* functionality in a class this means your
   overwrites will be lost into the wind when the original class gets loaded.
*  Relating to the first problem, if you simply use the `class` syntax to repoen
   a class and you are opening it for the first time, you can also run into a
   very obscure error of `superclass mismatch for class`.  If the original class
   definition loads second and tries to use a parent class this is what happens.
``` ruby
# what you think is re-opening, but is actually defining... 
class Widget
  def late?
    Time.now > due_date
  end
end

# ... the original defintion loading second

require 'ostruct'
class Widget < OpenStruct # TypeError: superclass mismatch for class Widget
  # ... stuff that doesn't matter
end
```
*  You are more prepared to move away from whatever it is you are patching.
   Sometimes this isn't possible, especially when you are patching a core class
   like `String`.  However; for some classes this is where you will want to
   head.

I hope this helps scratch the surface on monkey-patching and arms you with a bit
better knowledge of how and why to do it.  This is perhaps one of the greatest
double-edged swords at your disposal.  If you are working in a newer version of
Ruby and are feeling froggy, I would also recommend looking at 
[refinements](http://ruby-doc.org/core-2.1.1/doc/syntax/refinements_rdoc.html).
