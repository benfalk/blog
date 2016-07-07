---
layout: post
title: "Channels in Phoenix"
date: 2016-07-06 18:48:22 -0500
comments: true
categories:
- Elixir
- Phoenix
---

### The Back-Story

I've been writing Phoenix applications for about four months now and really
enjoy it so far; however, I've been stuck working mostly on boring web APIs and
haven't had a chance to build anything that is more rich and interactive with
a specific user application in mind.  That's all changed though as I decided to
beef up on my front-end skills a bit and work on a pet project I've had cooking
in the noodle for awhile now.

<!-- more -->

### What are Channels?

Chances are, if you've heard about Phoenix you've also heard people brag up the
"Channel" system that ships with it.  It gives you a great way to send real-time
updates to the browser and doesn't require a crazy amount of hardware to do it
either!  If you're familiar with
[MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) then
you can think of a channel as being a controller that maintains persistence and
a constant socket open with the browser.

What does that mean though?  Ask any web developer and they'll be able to tell
you about the life-cycle of a web request, which at it's heart is stateless.
This means every request you make to a web server requires it to build up state
every time you hop to a new page.  The overhead to build that up can be pretty
incredible.  With channels you're able to store the state and keep it around for
any requests that happen.

### Show Me Some Code Already

Let's peel back what is going on with these channels by snooping through some of
the code from a fresh install. First you'll want to direct your attention to
`lib/project_name/endpoint.ex`.  This is the starting code base for a request,
and right away one of the things we find is this (assuming your application is
named MyApp):

``` elixir
  socket "/socket", MyApp.UserSocket
```

If you're worked with `Plug` routing this should should feel pretty similar.
What's going on here is any requests to `/socket` are being handled by the
`MyApp.UserSocket` module.  Let's crack that open next and take a peek!

``` elixir
defmodule MyApp.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "rooms:*", MyApp.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(_params, socket) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     TaskMaster.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
```
Quite a bit is going on here, luckily a lot of it is being handled for us with
the `use Phoenix.Socket` statement.  This is where your web socket connection
becomes a channel.  Think of this module as being a initial starting point and
router for which the channel specific protocol takes shape.  The `channel` macro
wires up "topics" to more specific modules.  I like to think of topics as web
routes.  The `*` in the channel does what you would expect and allows anything
to match at that location.

Next up is the transport, I don't know much about this; but my assumption is
this specifies the underpinnings of how to actually talk with the web client.
Based on the commented out option of `:longpoll` it looks like this would
support older clients that don't have web socket support.  There are some
libraries out there that use a long polling ajax request to simulate websockets.

The comments do a pretty great job of explaining the rest of what's going on
here!  But what would a channel look like?  Here is the code for a channel that
I'm working on at the moment:

``` elixir
defmodule TaskMaster.ProjectChannel do
  @moduledoc """
  This module is responsible for the high level on-going with projects.
  It notifies users of when projects are created, deleted, or updated,
  and allows a user to also perform those actions as well.
  """
  use TaskMaster.Web, :channel

  def join("projects", _, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("create", project_params, socket) do
    case Project.new(project_params) |> Repo.insert do
      {:ok, project} ->
        broadcast! socket, "created", project
        {:reply, :ok, socket}

      {:error, _} ->
        {:reply, :error, socket}
    end
  end

  def handle_in("delete", %{"id"=>id}, socket) do
    case Repo.get(Project, id) do
      nil ->
        {:reply, :error, socket}

      project ->
        TaskMaster.Repo.delete(project)
        broadcast! socket, "deleted", project
        {:reply, :ok, socket}
    end
  end

  def handle_in("update", %{"id"=>id}=params, socket) do
    case Repo.get(Project, id) do
      nil ->
        {:reply, :error, socket}

      project ->
        case Project.changeset(project, params) |> Repo.update do
          {:error, _} ->
            {:reply, :error, socket}

          {:ok, project} ->
            broadcast! socket, "updated", project
            {:reply, :ok, socket}
        end
    end
  end

  def handle_info(:after_join, socket) do
    projects = Repo.all(Project)
    push(socket, "sync_project_list", %{projects: projects})
    {:noreply, socket}
  end
end
```

If you've worked with `GenServer` some of this is going to look eerily the same.
This is as much experience as I've had so far so I'll let the code do most of
the talking for now...  This post has gone on a bit long so we'll wrap up here
for now and dive in again in a second post with how to test this stuff, stay
tuned!
