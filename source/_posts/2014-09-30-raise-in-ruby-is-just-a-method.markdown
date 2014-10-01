---
layout: post
title: "'raise' in Ruby is just a method"
date: 2014-09-30 18:14:36 -0500
comments: true
categories: 
- Ruby
---
Today I was coding up a tricky bit of logic where I was using `BasicObject` to 
delegate all methods to another object it was encapsulating and I learned that
`raise` is not a keyword in ruby.

<!-- more -->

To give a bit of detail here is generically what I had coded up...

```ruby
class GateKeeper < BasicObject
  def initialize(obj)
    @obj = obj
  end

  def method_missing(method, *args, &block)
    @obj.send(method, *args, &block)
  rescue ::StandardError => error
    raise error unless method.to_s == 'pesky_method'
    # ... log things about failure and try known fallbacks
  end
end
```

Everything looks okay with this little patching class right?  Little did I know
I had created an infinte loop that was very difficult to debug.  I'll quickly
walk through the stack and explain what happened.

1. GateKeeper receives method `normal_method`
2. `method_missing` catches the call and sends the method to `@obj`
3. `normal_method` raises an exception that is rescued
4. `normal_method` does not equal `pesky_method` so the error is re-raised...
5. `raise` is not a method so it is sent to method missing
6. `raise` is called on `@obj` and an exception is raised, which is caught
7. `raise` is not equal to `pesky_method` so the error is re-raised...
8. ....

Now you understand the infinite loop.  This little bugger evaded me for awhile
and I learned a very powerful lesson, `raise` is just a method, not a keyword
in the ruby language.  If you find yourself havinging the same problem you can
use `Kernel.raise` to throw an exception.  Rule of thumb, when using
`BasicObject` don't expect any methods to work, including `raise` !
