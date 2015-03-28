---
layout: post
title: "Rails Precompile Failure with Bower Packages"
date: 2015-03-27 15:57:59 -0500
comments: true
categories: 
- Ruby
- Rails
---
I work with a team where we use bower packages in the
`vendor/assets/javascripts`.  Nothing to out of the ordinary, but to compile
them for production we use the following block in our `config/application.rb`:

``` ruby
  config.assets.precompile << Proc.new do |path|
    full_path       = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    if full_path.starts_with? app_assets_path
      if File.basename(full_path) =~ /^[^_]+(.*)\.(css|js)\.?(sass|scss)?$/
        puts "\e[0;32m✓ #{full_path}\e[0m"
        true
      else
        puts "\e[1;30m✗ #{full_path}\e[0m"
        false
      end
    end
  end
```

All was well with this up until a package was added that had a `bower.json` file
in it.  The package in our case was `requirejs-plugins`.  After adding this
package in, during an asset compile we were greated with the following error:

<!-- more -->

```
Sprockets::FileNotFound: couldn't find file 'requirejs-plugins/bower.json'
```

When you look in `vendor/assets/javascripts/requirejs-plugins` you can
clearly see there is a `bower.json` file, so what is the deal?  It turns out
Sprockets is to blame for this one, at least partially.  To better explain I'll
include the code in question; which was `2.12.3` as of this writing.

``` ruby
  # Finds the expanded real path for a given logical path by
  # searching the environment's paths.
  #
  #     resolve("application.js")
  #     # => "/path/to/app/javascripts/application.js.coffee"
  #
  # A `FileNotFound` exception is raised if the file does not exist.
  def resolve(logical_path, options = {})
    # If a block is given, preform an iterable search
    if block_given?
      require 'pry'
      args = attributes_for(logical_path).search_paths + [options]
      @trail.find(*args) do |path|
        pathname = Pathname.new(path)
        if %w( .bower.json bower.json component.json ).include?(pathname.basename.to_s)
          bower = json_decode(pathname.read)
          case bower['main']
          when String
            yield pathname.dirname.join(bower['main'])
          when Array
            extname = File.extname(logical_path)
            bower['main'].each do |fn|
              if extname == "" || extname == File.extname(fn)
                yield pathname.dirname.join(fn)
              end
            end
          end
        else
          yield pathname
        end
      end
    else
      resolve(logical_path, options) do |pathname|
        return pathname
      end
      raise FileNotFound, "couldn't find file '#{logical_path}'"
    end
  end
```

Wow, what is going on here??  Well it turns out this is trying to resolve asset
files for you.  It has some pretty good smarts to it; however, when you pass it
a `bower.json` file it attempts to match any assets defined in it that end in
`.json`.  This is where the the problem happens... there isn't a `.json` file
defined in the bower file.

To fix this I essentially had to catch the exception being raised in the do
block:

``` ruby
  config.assets.precompile << Proc.new do |path|
    begin
      full_path       = Rails.application.assets.resolve(path).to_path
      app_assets_path = Rails.root.join('app', 'assets').to_path
      if full_path.starts_with? app_assets_path
        if File.basename(full_path) =~ /^[^_]+(.*)\.(css|js)\.?(sass|scss)?$/
          puts "\e[0;32m✓ #{full_path}\e[0m"
          true
        else
          puts "\e[1;30m✗ #{full_path}\e[0m"
          false
        end
      end
    rescue Sprockets::FileNotFound => e
      puts "\x1b[31m✗ #{e.message}\e[0m"
      false
    end
  end
```

This isn't the best solution and I hope to do a touch of refactoring of this
over the weekend to make that `Sprockets::resolve` method a little better.
