---
layout: post
title: "Ruby Refactoring: Array#reduce and Default Variables"
date: 2014-11-06 09:26:53 -0600
comments: true
categories: 
- Ruby
- Ruby Golf
---

### Background

Earlier in the week, late one night I was working with the
[RAML](http://goo.gl/0OJJxf) data structure. It contains an array of resources,
each of which could in turn also have an array of resources inside of it.  Each
resource also has an array of `methods`, which in this case meant http verbs.

The structure from this perspective looks like this:

```
  RAML#
    resources# [
      resource#
        resources# []
        methods# []
    ]
    methods# []
```

In the spec there is no guarentee that a resource will contain any methods.  I
wanted to take this multi-deminsional structure and flatten it into an array of
resources where each resource had at least one method in it.

<!-- more -->

### Solution

My first pass at this, while working, wasn't my best work:

``` ruby

  def non_empty_resources
    resources = []
    @raml.resources.each do |resource|
      resources << resource if resource.methods.any?
      resources.concat any_from_below(resource)
    end
    resources
  end

  def any_from_below(resource)
    resources = []
    resource.resources.each do |r|
      resources << r if r.methods.any?
      resources.concat any_from_below(r)
    end
    resources
  end

```

Two methods to weed out non-empty resources... time to play some ruby golf.  The
first item to identify pretty quickly is both of these methods are similar...
using a little bit of ruby magic we can reduce this down to one method:

``` ruby

  def non_empty_resources(resource = @raml)
    resources = []
    resource.resources.each do |res|
      resources << res if res.methods.any?
      resources.concat non_empty_resources(res)
    end
    resources
  end

```

Taking advantage of being able to set the default variable to a class member
allows us to keep the orginal method's `non_empty_resources` similiar for any
exisiting code, while now being able to call itself instead of a helper method
that looks similiar. **Eight lines removed**

While this itself is a great improvement, there is another code sensor that
should be going off for any rubyist looking at this, and that is the lonley line
at the end where resources is being returned.  When you have one of these there
is normally something that can be done to fix it up, and for this we'll reach
for `reduce`.

``` ruby

  def non_empty_resources(resource = @raml)
    resource.resources.reduce([]) do |resources, res|
      resources << res if res.methods.any?
      resources.concat non_empty_resources(res)
    end
  end

```

The magic of reduce here is it takes our need to define an array outside of the
block away and then returns the value we need, sweet.  For those not familiar,
reduce passes the value from each block to the next block as the first block
variable, in our case `resources`, and the item being iterated over as the
second value, which is `res` in this example. By giving reduce an empty array it
will pass the first block iteration an array to start working from, by default
it uses `nil`.  **Ten lines removed**

I was able to remove a helper method as well as remove a total of ten lines of
source code.  Always a huge win being able to keep the same functionality and
remove that much noise.
