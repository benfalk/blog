---
layout: post
title: "Mumble Bot with Ruby"
date: 2014-03-19 08:31:30 -0700
comments: true
categories: 
- Ruby
---
Last week my brother wanted to make a Music Bot for mumble that would stream
music from [di.fm](http://goo.gl/KaSXkX).  He found a pretty cool project that
was started in ruby for a headless client.  [Here](http://goo.gl/ygU8lA) is the
link to that project. Being a ruby inclined person this seemed like a chance to
relax and do some code tinkering.

<!-- more -->

After an hour or so I came up with a small DSL that you can use with this
project to do things with the Bot.  So far it's not to extensive but I can see
myself moving this into a gem that has more power to it.
[Here](http://goo.gl/3QArhB) is what I have so far. 
``` ruby d_bot.rb
#!/usr/bin/env ruby

require './bot'

Bot.with_command 'setvol' do |val|
  `mpc volume #{val}`
end

Bot.start!
```

The d_bot.rb file is an example of the mumble bot receiving a command.  This
command is triggered by the mumblebot when you message it "!setvol 80".  The
bang denotes that it is a command and all other text past the command is
trimmed and passed to the do block to be used.  This is a simple example, I
would suggest guarding against injection attacks.

``` ruby

# Bot.start! accepts hash options for connecting to a mumble server
# ::host:: defaults to 'localhost'
# ::port:: defaults to 64738
# ::username:: defaults to 'MumbleBot'
# ::password:: defaults to ''
#
Bot.start! host: 'benfalk.com', port: 1234, username: 'Mumbler', password: 'pw'

```

