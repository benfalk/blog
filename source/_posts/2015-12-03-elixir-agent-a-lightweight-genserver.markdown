---
layout: post
title: "Elixir Agent - A Lightweight GenServer"
date: 2015-12-03 19:31:49 -0600
comments: true
categories: 
- elixir
---
If you come from Erlang and are familiar with the `GenServer` behaviour you may be
interested in the `Agent` set of methods that ship with Elixir.  They provide a
lightweight mechanic to save and retrieve state.  Here are two functionally
equivalent modules, one written as a `GenServer` and the other with `Agent`.

<!-- more -->

``` elixir
defmodule NumberGenerator do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, 1)
  end

  def next_number(pid) do
    GenServer.call(pid, :next_number)
  end

  def handle_call(:next_number, number) do
    {:reply, number, number + 1}
  end
end
```

``` elixir
defmodule NumberGenerator do
  def start_link do
    Agent.start_link(fn -> 1 end)
  end

  def next_number(pid) do
    Agent.get_and_update(pid, fn num -> {num, num + 1} end)
  end
end
```

Pretty nice how much you can shrink the code; and for things as trivial as this
you probably don't even need to have a module at all!  To be fair I used the
anonymous function version of `Agent`; which makes it seem a lot smaller.  Here
is the same one again with non-anonymous functions.

``` elixir
defmodule NumberGenerator do
  def start_link do
    Agent.start_link(__MODULE__, :init, [])
  end

  def next_number(pid) do
    Agent.get_and_update(pid, __MODULE__, :fetch_and_advance, [])
  end

  def init, do: 1
  def fetch_and_advance(number), do: {number, number + 1}
end
```
