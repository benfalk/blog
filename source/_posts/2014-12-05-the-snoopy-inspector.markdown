---
layout: post
title: "The Snoopy Inspector"
date: 2014-12-05 17:26:17 -0600
comments: true
categories: 
- Ruby
---
This week we had a very deep and hard to track down bug that was only happening
on certain Mac architectures.  The problem came down to setting shape object
data on ActiveRecord models and then mysteriously having that field become `nil`.

After setting pry breakpoints in several dozen places we still weren't any
closer to solving the problem.  The magic meta that ActiveRecord supplies was
making it an impossible exercise of patience to step through what seemed to be
several hundred stacks of a statement that was this simple on the outside:

``` ruby mark:3
  shape = FactoryGirl.create :spatial_rectangle
  rect = Shape.new
  rect.data = shape
```

<!-- more -->

I ended up writing this class to try to help narrow down our problem, and it
turned out to be increddibly helpful!

``` ruby
class Snoopy < BasicObject
  def initialize(obj)
    @obj = obj
  end

  def method_missing(method, *args, &block)
    mini_stack = ::Kernel.caller.to_a[1..3]
    @obj.send(method, *args, &block).tap do |val|
      @obj.send(:puts, "#{method} #{args} -> #{val}")
      @obj.send(:puts, "\t#{mini_stack.join("\n\t")}")
    end
  end
end
```

This snoopy class delegates all calls to the target @obj and prints helpful
debug information out on what is being called where. Using it like this yielded
some amazing information:

```ruby
  shape = Snoopy.new(FactoryGirl.create :spatial_rectangle)
  rect = Shape.new
  rect.data = shape
```

Here is the output it produced:
```
kind_of? [RGeo::Feature::Instance] -> false
        /gems/rgeo-0.3.20/lib/rgeo/feature/types.rb:100:in `check_type'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:166:in `convert_to_geometry'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:130:in `type_cast'

kind_of? [RGeo::Feature::Type] -> false
        /gems/rgeo-0.3.20/lib/rgeo/feature/types.rb:101:in `check_type'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:166:in `convert_to_geometry'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:130:in `type_cast'

respond_to? [:to_str] -> true
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:169:in `convert_to_geometry'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:130:in `type_cast'
        /gems/activerecord-3.2.19/lib/active_record/attribute_methods/dirty.rb:86:in `_field_changed?'

to_str [] -> SRID=4326;MULTIPOLYGON(((135.52090361935.1378784290001,135.602039081 35.1685108510002,...
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:170:in `convert_to_geometry'
        /gems/activerecord-postgis-adapter-0.6.5/lib/active_record/connection_adapters/postgis_adapter/rails3/spatial_column.rb:130:in `type_cast'
        /gems/activerecord-3.2.19/lib/active_record/attribute_methods/dirty.rb:86:in `_field_changed?'
```

Using this we were able to quickly narrow down the problem in the postgis
adapter gem.  If you ever find yourself in this same problem, maybe Snoopy can
help you to :)
