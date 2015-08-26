---
layout: post
title: "Test the Order of Calls with RSpec"
date: 2015-08-26 16:48:47 -0500
comments: true
categories: 
- ruby
---
When coding sometimes it's difficult to think through edge cases of what will
happen when.  Instead of thinking to hard about it let RSpec do the heavy
lifting for you!  Pretend you have the following `Fetcher` class responsible for
performing http requests and retrying when the host sever has problems:

<!-- more -->

``` ruby
  class Fetcher
    attr_reader :urls, :retry_limit
    RetryLimitExceeded = Class.new(Exception)
    SERVER_ERROR_CODES = (500..599)

    def initialize(urls, retry_limit: 5)
      @urls = urls
      @retry_limit = retry_limit
    end

    def call
      uris.map do |uri|
        fetch(uri)
      end
    end

    private

    def fetch(uri)
      retry_count = 1
      loop do
        response = Net::HTTP.get_response(uri)
        return response unless SERVER_ERROR_CODES.include? response.code.to_i
        fail RetryLimitExceeded if retry_count > retry_limit
        sleep(2 ** retry_count)
        retry_count += 1
      end
    end

    def uris
      urls.map(&method(:URI))
    end
  end
```

Right away we can see that the `fetch` method is doing the heavy lifting in this
class.  Just looking at it causes my head to start spinning. Versus trying to
run this code in your head to reason if the code is working correctly let's test
it instead!

``` ruby
  describe Fetcher do
    let(:urls)        { %w(http://benfalk.com) }
    let(:response)    { double(:response, code: '200', body: 'Ahoy!') }
    let(:retry_limit) { 3 }
    let(:instance)    { described_class.new(urls, retry_limit: retry_limit) }

    before  { allow(Net::HTTP).to receive(:get_response).and_return(response) }

    context 'when the response code is 200' do
      subject { instance.call }
      it { is_expected.to eq [response] }
    end

    context 'when the response is nothing but 503' do
      before { allow(response).to receive(:code).and_return('503') }
      after { expect { instance.call }.to raise_error(Fetcher::RetryLimitExceeded) }

      it do
        expect(instance).to receive(:sleep).exactly(retry_limit).times
      end

      it do
        expect(instance).to receive(:sleep).with(2).ordered
        expect(instance).to receive(:sleep).with(4).ordered
        expect(instance).to receive(:sleep).with(8).ordered
      end
    end

    context 'when the response is 503 twice then succeeds' do
      before do
        expect(response).to receive(:code).and_return('503').ordered 
        expect(response).to receive(:code).and_return('503').ordered 
        expect(response).to receive(:code).and_return('200').ordered 
      end
      
      it 'should still return the response' do
        expect(instance).to receive(:sleep).exactly(2).times
        expect(instance.call).to eq [response]
      end
    end
  end
```

The meat and potatoes of the test here is making sure that `sleep` is called for
each retry.  On lines 23 - 25 we can see that if the response always comes back
as a `503` then we expect sleep to be called with `2`, `4`, and `8`.  The
`ordered` part of RSpec mocks preserves the order.  Another great use of
`orderd` is on lines 31 - 33.  Here we only want it to fail twice then succeed
on the third attempt.  One thing I learned was this only works with `expect`.
The following code will **not** work.

``` ruby
  allow(response).to receive(:code).and_return('503').ordered 
  allow(response).to receive(:code).and_return('503').ordered 
  allow(response).to receive(:code).and_return('200').ordered 
```

In this case, `allow` overrides previous mock setups.  When run this code is run
it `response` will always return 200.  
