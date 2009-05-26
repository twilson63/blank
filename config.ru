require 'sinatra'
require 'haml'

set :environment, :development
disable :run


require 'blank.rb'

run Sinatra::Application