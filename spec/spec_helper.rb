require 'rubygems'
require 'blank'  # <-- your sinatra app
require 'spec'
require 'spec/interop/test'
require 'rack/test'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha 
end

set :environment, :test

def app
  Sinatra::Application
end
