---
layout: post
title: "Testing Against Multiple Rails Versions"
date: 2014-09-28 10:54:08 -0500
comments: true
categories: 
- Ruby
---
Recently I wrote a Rails engine gem [password_required](http://goo.gl/lB0tJY).
One of the first problems I ran into was not knowing what versions of Rails it
would work with, so I kept the dependency rigid, "~> 4.1.6".  That of course
alienated anyone working from the 4.0.x branch. I looked around at different
packages to see how they handle this, and here is the solution I landed on.

<!-- more -->

First, ditch your Gemfile.lock and add it to your .gitignore, it will give you
headaches when trying to bundle different versions of Rails for testing.

Next the following is found in my Gemfile..

```ruby Gemfile
rails_version = ENV['RAILS_VERSION'] || 'default'
rails = case rails_version
        when 'master'
          { github: 'rails/rails' }
        when 'default'
          '~> 4.1'
        else
          "~> #{rails_version}"
        end
gem 'rails', rails
```

And you will need to alter your specfile...

```ruby gemspec
Gem::Specification.new do |s|
  s.add_dependency 'rails', '~> 4'
  # ...
end
```

This lets you do the following to test against rails 4.0 :

```bash
export RAILS_VERSION=4.0.0
bundle && rake
export RAILS_VERSION=default
```

The code could be better for this but you get the point.  If you are using
Travis to test this makes it pretty simple, here is my travis file env.

```yaml
env:
  - "RAILS_VERSION=4.1.0"
  - "RAILS_VERSION=4.0.0"
```

Probably the biggest pain I had in this whole process was some of the errors I
had to deal with in my `spec/dummy` rails testbed.  Since I started with 4.1
there were boilerplate problems I ran into when trying to use 4.0.  Here were
the changes I had to make

```ruby spec/dummy/config/environments/development.rb
# This doesn't work for rails 4.0 yo
# Rails.application.configure do
Dummy::Application.configure do
```

```ruby spec/dummy/config/environments/test.rb
# This doesn't work for rails 4.0 yo
# Rails.application.configure do
Dummy::Application.configure do
  config.secret_key_base = 'xxxxx'
```

I tried briefly to go back as far as rails 3.2 but had a lot of issues so I
stuck with 4.0 + for now.  Hopefully this is helpful to anyone else who is
looking to support multiple branches of rails in their gem.
