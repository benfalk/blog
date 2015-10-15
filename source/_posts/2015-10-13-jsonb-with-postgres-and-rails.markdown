---
layout: post
title: "JSONb with Postgres and Rails"
date: 2015-10-13 07:03:35 -0500
comments: true
categories: 
- Ruby
- PostgreSQL
---
If you're using ActiveRecord 4.2+ you're in luck.  It carries support for
Postgres' `JSONb` feature.  `JSONb`, and it's cousin `JSON` allow you to
store json natively as a column in your database tables.  The power of these
is being able to then query directly against data stored in the data.  For
instance the following query would be able to grab all email addresses where the
json column _"preferences"_ has a key of **contact_me** set to true.

``` sql
-- json
SELECT email FROM users WHERE preferences->>'contact_me' = 'true';

-- jsonb
SELECT email FROM users WHERE preferences @> '{"contact_me":true}';
```

<!-- more -->

If you are using 9.4+ of Postgres you can take advantage of `JSONb`; which
supports indexing and faster key access of values.  The 9.3 series only has
support for `JSON`; which is slower when doing queries because it has to perform
a table scan when performing a query and the entire json hash has to be read to
extract the value of a key from it.

## Adding Column in a Rails Migration

``` ruby
# json format
add_column :table_name, :column_name, :json

# jsonb format
add_column :table_name, :column_name, :jsonb, null: false, default: '{}'
add_index :table_name, :column_name, using: :gin
```

## Changing From a Text Column in a Rails Migration

* Use this if you are serializing json into a text column currently
* Make sure you always have a back-up of production before migrating!

``` ruby
# json format
change_column :table_name, :change_column, :json, using: 'column_name::json'

# jsonb format
change_column :table_name, :change_column, :jsonb, using: 'column_name::jsonb'
add_index :table_name, :column_name, using: :gin
```

## Querying with ActiveRecord

[Operator List](http://www.postgresql.org/docs/9.4/static/functions-json.html)

``` ruby
# jsonb format
# details->gift_message OR details->shipping_extra
Order.where('details ?| array[:keys]', keys: %w(shipping_extra gift_message))

# details->gift_message AND details->delivery_contact
Order.where('details ?& array[:keys]', keys: %w(delivery_contact gift_message))

# preferences->contact_me = true AND preferences->veteran = true
User.where('preferences @> ?', {contact_me: true, veteran: true}.to_json)
```
