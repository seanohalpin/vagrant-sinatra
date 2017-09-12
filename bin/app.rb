#!/usr/bin/env ruby
# * Minimal example app using Sinatra and ActiveRecord
require 'sinatra'
require 'active_record'

# ** Configure Sinatra
configure do
  # port/ip address
  set :port, ENV.fetch('SINATRA_PORT', 5000).to_i
  set :bind, ENV.fetch('SINATRA_IP', '0.0.0.0')
end

# ** Set up db connection
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => ENV["MYSQL_APP_HOST"],
  :database => ENV["MYSQL_APP_DB"],
  :username => ENV["MYSQL_APP_USERNAME"],
  :password => ENV["MYSQL_APP_PASSWORD"],
)

# ** Create User and table
class User < ActiveRecord::Base
end

if not ActiveRecord::Base.connection.table_exists? :users
  ActiveRecord::Migration.create_table :users do |t|
    t.string :name
  end
  User.create(name: "Rick")
  User.create(name: "Morty")
end

# * Routes
get '/' do
  User.all.to_json
end
