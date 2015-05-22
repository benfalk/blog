---
layout: post
title: "Rspec and the Double Dilemma"
date: 2015-05-21 21:41:45 -0500
comments: true
categories: 
- Ruby
---
This week the question came up of doubles with Rspec testing. For those
unfamiliar with this concept, a double is a way of creating fake resources that
look and act like the resources you expect to be used inside of a class or
method.  With the newer versions of Rspec this is as simple as the following
example:

```ruby

describe MaintenanceSystem do
  let(:bad_spring) { double(type: :general, size: :small, condition: :poor) }
  let(:resource)   { double(springs: [bad_spring]) }
  let(:system)     { described_class.new(loaded_resources) }

  context 'with a single small spring loaded in resources' do
    let(:good_spring) { double(type: :general, size: :small, condition: :good) }
    let(:loaded_resources) { { springs: [good_spring] } }

    it 'should be able to make the repair' do
      expect(system.can_repair? resource).to be(true)
    end

    context 'but the resource has a large bad spring' do
      let(:bad_spring) { double(type: :general, size: :large, condition: :poor) }

      it 'should not be able to make the repair' do
        expect(system.can_repair? resource).to be(false)
      end
    end
  end
end

```

<!-- more -->

This lets you create and test your `MaintenanceSystem` without actually needing
to get other real resources available.  Case in point I was able to make these
two tests pass with the following implementation:

``` ruby

class MaintenanceSystem
  attr_accessor :resources

  def initialize(**resources)
    @resources = resources
  end

  def can_repair?(resoure)
    bad_springs = resoure.springs.select { |spring| spring.condition == :poor }
    good_springs_tally = tally_springs(good_springs)
    bad_springs_tally = tally_springs(bad_springs)
    bad_springs_tally.each_pair do |type, amount|
      return false if good_springs_tally[type] < amount
    end
    true
  end

  private

  def good_springs
    resources[:springs] || []
  end

  def tally_springs(springs)
    springs.each_with_object(Hash.new {0}) do |spring, hash|
      hash[[spring.type, spring.size]] += 1
    end
  end
end
```

This is all fine and dandy; however, some would argue it's not really testing as
much as it could.  You could say that in our _real world_ system if we change
how a resource works these tests would never discover the breaking change.  This
is the dilemma of using doubles, and it is a fact you have to deal with when
using doubles.  Hopefully you have feature tests in place that exercise these,
but if you don't a compromise you may be able to do is to utilize Rspecs stubbing
capability.  For example, these tests could have been done like this:


``` ruby mark:3,7

describe MaintenanceSystem do
  let(:bad_spring) { double(type: :general, size: :small, condition: :poor) }
  let(:resource)   { Widget.new }
  let(:system)     { described_class.new(loaded_resources) }

  context 'with a single small spring loaded in resources' do
    before { allow(resource).to receive(:springs).and_return([bad_spring]) }
    let(:good_spring) { double(type: :general, size: :small, condition: :good) }
    let(:loaded_resources) { { springs: [good_spring] } }

    it 'should be able to make the repair' do
      expect(system.can_repair? resource).to be(true)
    end

    context 'but the resource has a large bad spring' do
      let(:bad_spring) { double(type: :general, size: :large, condition: :poor) }

      it 'should not be able to make the repair' do
        expect(system.can_repair? resource).to be(false)
      end
    end
  end
end
```

With this before block, we are making a pact with the widget in a sense.  Rspec
will throw an exception if the `Widget` does not at least implement a `springs`
method... which is a tad bit of coupling.  If you are okay with this then you
will get a little more insight into any breakage that may crop up with regards
to widgets as they work with the `MaintenanceSystem`.

I don't know how much I am on board with this idea, but, it seems like a
pragmatic solution for testing when you don't have a good case or time to have
suitable feature tests in place.
