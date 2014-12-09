---
layout: post
title: "Ruby Refactoring: Ugly Null Checking"
date: 2014-12-08 18:14:57 -0600
comments: true
categories: 
- Ruby
- Refactoring
---
When you can, always try to use the
[Null Object Pattern](/blog/2014/11/12/ruby-refactoring-null-object-pattern-and-openstruct/);
however, there are times that may prove difficult.  This doesn't mean you need
to abandon all readability though.  Here is a block of code I ran into today
that was improved with a little refactoring TLC.

### Before
``` ruby
items.each do |item|
  next unless item.widget
  update_widget! item.widget
end
```

### After
``` ruby
items.each do |item|
  next if item.widget.nil?
  update_widget! item.widget
end
```

Just because `nil` is conveniently _falsey_ doesn't mean it's always best to
treat it that way.  Compare the before and after blocks above.  Which has
clearer intent on why next is called?  I'm sure if you read it a bit the first
makes sense, but the whole point is to avoid the necessity of reading code that
much to figure out what it's doing.

This is one of the cooler idioms I love about Ruby.  `nil?` is baked into nil to
be true and on `Object`, everything else, it's false.  Using this makes your code
more readable, use it every chance you get instead of that ugly null boolean
check!


