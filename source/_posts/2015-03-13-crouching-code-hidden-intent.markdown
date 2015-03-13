---
layout: post
title: "Crouching Code, Hidden Intent"
date: 2015-03-13 09:06:42 -0500
comments: true
categories: 
- Ruby
---
Yesterday I was looking at some Ruby code that had an `initialize` method like
this:

``` ruby
def initialize(data)
  @data = data
  @data = Wrapper.new(data) if data.is_a? Hash
end
```

This code has _hidden intent_ that could be easier to read.  By assigning
`@data` possibly twice it forces the reader to keep extra context in their head
while reading and masks intent.  The intent of this code is to assign `@data`
with whatever is passed in, unless it's a `Hash`, if it's a `Hash` it's supposed
to be a `Wrapper`.

Let's see if we can write this a little better to help bring that intent
forward:

``` ruby
def initialize(data)
  @data =
    if data.is_a? Hash
      Wrapper.new(data)
    else
      data
    end
end
```

This has removed the double assignment and focused on the fact that `@data` is
either going either one or the other of something.  One thing to note is this
has added lines of code to the definition, but I feel they are worth it.
Another way you could layout this method and slim it down would be like this:

``` ruby
def initialize(data)
  @data = data.is_a?(Hash) ? Wrapper.new(data) : data
end
```

I am not a big fan of the above examle; but some might love it... Here would be
my best solution idea for the code currently:

``` ruby
def initialize(data)
  @data = transform_format(data)
end

private

def transform_format(data)
  case data
  when Hash
    Wrapper.new(data)
  else
    data
  end
end
```

This adds even more lines!  However, it adds more description into what is going
on as well.  `@data` is being transformed, and if you want to see what that
means you can look at the method `transform_format` to see exactly what that
means.
