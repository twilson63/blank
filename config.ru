require 'rubygems'
require 'sinatra'
require 'blank'

# path = ''
# 
# set :root, path
# set :views, path + '/views'
# set :public, path + '/public'

# set :raise_errors, true 
 
# sinatra doesn't have anything built in for logging so you can use the stdout to log to a file
# log = File.new("sinatra.log", "a")
# STDOUT.reopen(log)
# STDERR.reopen(log)


set :environment, :production
disable :run

run Sinatra::Application
