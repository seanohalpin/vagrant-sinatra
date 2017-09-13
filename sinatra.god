# -*- mode: ruby; -*-
# vi: set ft=ruby :
SINATRA_HOME = File.dirname(__FILE__)

God.watch do |w|
  w.name     = "sinatra-app"
  w.group    = "web"
  w.interval = 30.seconds
  w.env      = {}
  w.dir      = SINATRA_HOME
  w.start    = "bin/app.rb"

  w.log = "#{SINATRA_HOME}/log/server.log"

  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
