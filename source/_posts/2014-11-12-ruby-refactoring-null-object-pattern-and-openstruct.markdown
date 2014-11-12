---
layout: post
title: "Ruby Refactoring: Null Object Pattern and OpenStruct"
date: 2014-11-12 08:55:12 -0600
comments: true
categories: 
- Ruby
- Refactoring
---

### Background

Sometime ago I found a bug in my [RAML](http://goo.gl/0OJJxf) logic where it
wasn't accounting for the fact that a raw response could have no bodies.  This
was breaking my [CrystalForge](http://goo.gl/5WNIwE) webserver as it relied on a
body being present.  Here is the _quick_ code fix put together to get this going
again:

<!-- more -->

``` ruby Highlighted lines are where things were "fixed"  mark:14,43,59

    ##
    # Wraps a given raml response to have the same duct type
    # as an api blueprint example
    class RawExample
      ##
      # @param [Raml::Response] response
      def initialize(response)
        @response = response
      end

      ##
      # @return [Array<RAML::RawResponse>]
      def responses
        return [RawResponse.new(nil, response)] if response.bodies.empty?
        response.bodies.map { |body| RawResponse.new(body, response) }
      end

      private

      attr_reader :response
    end

    ##
    # response that is similiar to an API blueprint response
    class RawResponse
      ##
      # @param [Raml::Body] raw_body
      # @param [Raml::Response] response
      def initialize(raw_body, response)
        @raw_body = raw_body
        @response = response
      end

      ##
      # @return [String] status html code
      def name
        response.code.to_s
      end

      ##
      # @return [String] html body
      def body
        return '' if raw_body.nil?
        raw_body.example
      end

      ##
      # @return [RAML::RawResponse, #collection]
      def headers
        self
      end

      ##
      # @example
      #   [{ name: 'Content-Type', value: 'text/html' }]
      # @return [Array<Hash>] array of name, value pair hashes for
      #   html headers
      def collection
        return [] if raw_body.nil?
        [{ name: 'Content-Type', value: raw_body.content_type }]
      end

      private

      attr_reader :raw_body, :response
    end

```

### Solution

This got everything up and working again, but there had to be a better
way to write this.  I decided to remove the nil I was initializing the
`RawResponse` with and instead send a Null representation of the body instead.
Using OpenStruct you can mimic whole objects that are normally "outside" of your
control, which helped out nicely with this refactor.  Here is the code
afterwards:

``` ruby Highlighted lines are the refactor magic mark:7,13,19,24,47,62
    ##
    # Wraps a given raml response to have the same duct type
    # as an api blueprint example
    class RawExample
      ##
      # Empty body to send when no bodies are found
      NullBody = OpenStruct.new(example: '', content_type: '').freeze

      ##
      # @param [Raml::Response] response
      def initialize(response)
        @response = response
        @bodies = response.bodies.empty? ? [NullBody] : response.bodies
      end

      ##
      # @return [Array<RAML::RawResponse>]
      def responses
        bodies.map { |body| RawResponse.new(body, response) }
      end

      private

      attr_reader :response, :bodies
    end

    ##
    # response that is similiar to an API blueprint response
    class RawResponse
      ##
      # @param [Raml::Body] raw_body
      # @param [Raml::Response] response
      def initialize(raw_body, response)
        @raw_body = raw_body
        @response = response
      end

      ##
      # @return [String] status html code
      def name
        response.code.to_s
      end

      ##
      # @return [String] html body
      def body
        raw_body.example
      end

      ##
      # @return [RAML::RawResponse, #collection]
      def headers
        self
      end

      ##
      # @example
      #   [{ name: 'Content-Type', value: 'text/html' }]
      # @return [Array<Hash>] array of name, value pair hashes for
      #   html headers
      def collection
        return [] if raw_body.content_type.empty?
        [{ name: 'Content-Type', value: raw_body.content_type }]
      end

      private

      attr_reader :raw_body, :response
    end
```

This has removed the complexity of both `RawResponse` and `RawExample` by a good
bit.  `RawExample#responses` no longer needs to worry about bodies being in a
good valid state, it can just map over them and know that each one is valid.

`RawResponse#body` no longer needs to have the responsibility of making sure body is
`nil` anymore and can return back to expecting #example having the right answer.

The next time you find yourself wanting to pass `nil` and have it mean
something, instead consider using the [NullObject Pattern](http://goo.gl/OwGsF3),
and if you have Ruby in your toolbelt remember that `OpenStruct` may be the best
fit for the bill.
