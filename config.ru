require 'sinatra'
require 'haml'
require 'rdiscount'
require 'json'
require 'activerecord'
require 'crack'
require 'rest_client'
require 'cgi'

set :environment, :development
disable :run


require 'blank.rb'

run Sinatra::Application