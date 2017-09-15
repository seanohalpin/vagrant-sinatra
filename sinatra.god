# -*- mode: ruby; -*-
# vi: set ft=ruby :
SINATRA_HOME = File.dirname(__FILE__)

# SINATRA_HOME = "/vagrant"

God.watch do |w|
  w.name     = "sinatra-app"
  w.group    = "web"
  w.interval = 30.seconds
  # w.uid      = 'vagrant' # Note: do not specify uid if User set in /etc/systemd/system/god.service
  w.env      = {
    "RBENV"               => "2.4.2",
    "MYSQL_ROOT_PASSWORD" => "root123",
    "MYSQL_APP_HOST"      => "localhost",
    "MYSQL_APP_DB"        => "sinatra_app_db",
    "MYSQL_APP_USERNAME"  => "sinatra_app_user",
    "MYSQL_APP_PASSWORD"  => "app123",
  }
  w.dir      = SINATRA_HOME
  w.start    = "#{SINATRA_HOME}/bin/app.rb"
  w.log      = "#{SINATRA_HOME}/log/server.log"

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
