---
layout: post
title: "Empty Raise and Rescue"
date: 2014-12-04 18:27:43 -0600
comments: true
categories: 
- Ruby
---
I was helping debug some open source ruby code today and saw a code block that
looked like this:

```ruby

  def risky_method
  # Logic Here ...
  rescue
    # Logging and record cleanup
    raise
  end
```

<!-- more -->

This is yet another clean way Ruby provides us with controlling program flow.
The block of code doesn't care about what is being rescued; nor does it plan to
correct what has happened.  All it wants to do is fix any global state that was
broken, log the details as close to the impact, and then re-raise the error for
some other logic to handle.

With a blind rescue, if you call raise inside the rescue segment it will
re-raise the exception that was being rescued.  This helps prevent code that may
not be as obvious, such as this code:

``` ruby
  def risky_method
  # Logic Here ...
  rescue StandardError => e
    # Logging and record cleanup
    raise e
  end
```

This code does exactly the same thing as the first code example, but now has the
reader wondering why we are rescuing from `StandardError` specifically and not
some other error.  The first code block spells out it's intent on the fact it
doesn't expect any specific kind of error and helps maintain focus on the
logging and record cleanup that it is actually trying to do.
