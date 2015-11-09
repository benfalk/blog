---
layout: post
title: "Playing with JSONb and Postgres"
date: 2015-11-08 18:11:15 -0600
comments: true
categories: 
- PostgreSQL
---
This week I had the opportunity to play around with JSONb, a feature added to
Postgres 9.4.  It is similar to the native JSON column introduced in 9.3 but
with some extra benefits.  The two largest values that I have found so far is
that JSONb can be indexed and the cost of selecting keys is quite a bit less.  I
also made a Ruby/Docker playground you can use to run some tests yourself.
Check out [jsonb_tests](https://github.com/benfalk/jsonb_tests) if you would
like to try some of these features out yourself!

<!-- more -->

## Benchmarks Against Different Types

For the listed benchmarks I created two tables, a `users` table and a
`customers` table. They both have a million records with a `details` field that
has the following structure:

```
{
  address: {
    city: String,
    street_address: String,
    zip: String,
    state: String,
  contact_me: Boolean,
  first_name: String,
  last_name: String,
  age: Integer,
  bio: String
}
```

The difference being that the `users` table is JSONb with a `GIN` index and the
`customers` table is using standard JSON.

### Different Ways to Count

```
select count(*) from users
 where details->>'contact_me' = 'true'; (took 0.4313037639999493 seconds)

select count(*) from customers
 where details->>'contact_me' = 'true'; (took 2.5200677539999106 seconds)

select count(*) from users
 where details->'address'->>'state' = 'IN'; (took 0.4488999090001471 seconds)

select count(*) from customers
 where details->'address'->>'state' = 'IN'; (took 3.187369449000016 seconds)

select count(*) from users
 where details @> '{"contact_me":true}'; (took 0.530210845000056 seconds)

select count(*) from users
 where details @> '{"address":{"state":"IN"}}'; (took 0.13651816199990208 seconds)
```

### Aggregation

```
select AVG(cast(details->>'age' as integer)) from users; (took 0.4856294619999062 seconds)
select AVG(cast(details->>'age' as integer)) from customers; (took 2.5806195400000433 seconds)
```

### Raw Read Speed

```
select * from users limit 10000; (took 0.33650682899997264 seconds)
select * from customers limit 10000; (took 0.3063410740001018 seconds)
```

### OR Type Selection

```
select count(*) from users
 where details->'address'->'state' ?| array['TN', 'IN']; (took 0.6990287710000302 seconds)

select count(*) from users
 where details @> '{"address":{"state":"IN"}}'
 OR details @> '{"address":{"state":"TN"}}'; (took 0.1888019399998484 seconds)

select count(*) from users
 where details->'address'->>'state' IN ('TN', 'IN'); (took 0.5302666719999252 seconds)

select count(*) from customers
 where details->'address'->>'state' IN ('TN', 'IN'); (took 3.241861794999977 seconds)
```
