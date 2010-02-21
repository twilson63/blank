require 'rubygems'
require 'blank'  # <-- your sinatra app
require 'spec'
require 'spec/interop/test'
require 'rack/test'

Spec::Runner.configure do |config|

end

set :environment, :test

def app
  Sinatra::Application
end
