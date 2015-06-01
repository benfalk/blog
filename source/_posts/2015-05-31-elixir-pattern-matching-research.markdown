---
layout: post
title: "Elixir Pattern Matching Research"
date: 2015-05-31 11:42:04 -0500
comments: true
categories: 
- Elixir
---
At the start of the week I started reading _Metaprogramming Elixir_ by Chris
McCord.  One of the items you quickly learn is just how easy it is to
programmatically create methods that can be compiled into your application.  One
of the examples in the book that is cited from this is how the `Unicode.upcase`
method is delegated to down to methods that are created at compile time from a
file.  [Here is where you can find this being used](https://goo.gl/CD6xWo)

<!-- more -->

After seeing this I began to wonder what the _"performance"_ of matching was in
the Elixir system.  So I wired up some tests to begin identifying this for myself.
To me it would seem that since the order of the methods is important; the best
you could get was linear growth in lookup time.  Meanwhile if you have a more
robust data structure that can avoid doing this kind of lookup I would assume it
to be faster.

These are the two different modules I put together, building both of them from
my local dictionary of about ninety-nine thousand words:

``` elixir

defmodule PatternPerformance.Matching do
  @external_resource words_file = Path.join([__DIR__, "../words.txt"])
  for word <- File.stream!(words_file, [], :line) do
    word = String.strip(word)
    def is_word?(unquote(word)), do: true
  end
  def is_word?(_word), do: false
end
```
The `PatternPerformance.Matching` module creates close to 100 thousand methods
where it matches literally on the word given and returns a simple `true`.  Then
at the end it has a catch all that returns false.  I'm not sure how great this
would be for production, but it serves for what I am testing.  Some things to
note about this module is it took 6 minutes and 23 seconds to compile on my
Macbook Pro and the binary it generates is a little over three megabytes big.

``` elixir

defmodule PatternPerformance.HashDict do
  @external_resource words_file = Path.join([__DIR__, "../words.txt"])
  @words File.stream!(words_file, [], :line)
          |> Enum.map(&String.strip(&1))
          |> Enum.reduce(HashDict.new, fn word, acc ->
            HashDict.put(acc, word, true)
          end)
  def is_word?(word), do: HashDict.get(@words, word, false)
end
```

The `PatternPerformance.HashDict` module creates a `HashDict` structure at
compile time and sets it as @words.  The `is_word?` function defined simply
references this structure, returning is value which is true, and is given
`false` as the default value to return if the key is not found.  Items to note
about this module is it takes about 4 seconds to compile and is 1.6 megabytes
big.

To test both of these I created the following crude module: 

``` elixir

defmodule PatternPerformance do
  defstruct slowest_time: 0,
            total_time: 0,
            words_tried: 0

  def words do
    File.read!(Path.join([__DIR__, "../words.txt"]))
      |> String.split("\n")
  end

  def record_access(module) do
    # "Warming" up the system
    module.is_word?("apple")
    Enum.reduce(words, %PatternPerformance{}, fn word, performance ->
      time =
        case :timer.tc(module, :is_word?, [word]) do
          {t, true} -> t
          {t, false} ->
            IO.puts "Word '#{word}' not found!"
            t
        end
      %{performance |
        slowest_time: max(time, performance.slowest_time),
        words_tried: performance.words_tried + 1,
        total_time: performance.total_time + time
      }
    end)
  end
end
```

After several tests there was a clear winner...

``` elixir

PatternPerformance.record_access(PatternPerformance.HashDict)
# %PatternPerformance{slowest_time: 293, total_time: 49189, words_tried: 99172}
# %PatternPerformance{slowest_time: 1835, total_time: 47322, words_tried: 99172}
# %PatternPerformance{slowest_time: 1861, total_time: 47508, words_tried: 99172}
# %PatternPerformance{slowest_time: 2049, total_time: 57061, words_tried: 99172}

PatternPerformance.record_access(PatternPerformance.Matching)
# %PatternPerformance{slowest_time: 1983, total_time: 21555, words_tried: 99172}
# %PatternPerformance{slowest_time: 2147, total_time: 22174, words_tried: 99172}
# %PatternPerformance{slowest_time: 2079, total_time: 22341, words_tried: 99172}
# %PatternPerformance{slowest_time: 1584, total_time: 21110, words_tried: 99172}
```

The `PatternPerformance.Matching` was about twice as fast at coming back with
the correct answer!  This is not what I was suspecting, and as such I wanted to
believe perhaps something was not right with the `HashDict` structure so I
created two more test modules to try out the tried-and-true Erlang `gb_trees`
and `gb_sets`.

``` elixir

defmodule PatternPerformance.GBSet do
  @external_resource words_file = Path.join([__DIR__, "../words.txt"])
  @words File.stream!(words_file, [], :line)
          |> Enum.map(&String.strip(&1))
          |> Enum.reduce(:gb_sets.new, fn word, acc ->
            :gb_sets.insert(word, acc)
          end)
          |> :gb_sets.balance
  def is_word?(word), do: :gb_sets.is_member(word, @words)
end
```

``` elixir

defmodule PatternPerformance.GBTree do
  @external_resource words_file = Path.join([__DIR__, "../words.txt"])
  @words File.stream!(words_file, [], :line)
          |> Enum.map(&String.strip(&1))
          |> Enum.reduce(:gb_trees.empty, fn word, acc ->
            :gb_trees.enter(word, true, acc)
          end)
          |> :gb_trees.balance
  def is_word?(word), do: :gb_trees.is_defined(word, @words)
end
```

``` elixir

PatternPerformance.record_access(PatternPerformance.GBSet)
# %PatternPerformance{slowest_time: 172, total_time: 69402, words_tried: 99172}
# %PatternPerformance{slowest_time: 116, total_time: 68816, words_tried: 99172}
# %PatternPerformance{slowest_time: 117, total_time: 68723, words_tried: 99172}
# %PatternPerformance{slowest_time: 115, total_time: 69169, words_tried: 99172}

PatternPerformance.record_access(PatternPerformance.GBTree)
# %PatternPerformance{slowest_time: 127, total_time: 73446, words_tried: 99172}
# %PatternPerformance{slowest_time: 117, total_time: 74925, words_tried: 99172}
# %PatternPerformance{slowest_time: 126, total_time: 75926, words_tried: 99172}
# %PatternPerformance{slowest_time: 115, total_time: 73989, words_tried: 99172}
```

These were even slower!  Although an interesting note that their _"slowest"_
times were way faster than the pattern matching and `HashDict` slowest lookup
times on average.  I guess for now I am left with more questions than answers;
however for the time it appears compiling in a bunch of methods may be your best
bet when referring to a static list of values.

If you want to tinker with this yourself I threw up all of my code in a simple
mix project on my github: [elixir_pattern_performance](https://goo.gl/FPJf8f)
