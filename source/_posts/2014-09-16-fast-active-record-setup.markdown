---
layout: post
title: "Fast Active Record Setup"
date: 2014-09-16 21:18:08 -0500
comments: true
categories: 
- Ruby
---
Was doing some prototyping today that required some deeper knowledge of how
active record transactions work.  From doing my spike I found a great light
weight setup to tinker around with Active Record and felt it should be shared.

```ruby
require 'active_record'
 
ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :widgets do |table|
    table.column :name, :string
  end

  create_table :bits do |table|
    table.column :widget_id, :integer
    table.column :name, :string
  end
end

class Widget < ActiveRecord::Base
  has_many :bits
end

class Bit < ActiveRecord::Base
  belongs_to :widget, touch: true
end
```
