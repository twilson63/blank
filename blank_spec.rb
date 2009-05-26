require 'blank'  # <-- your sinatra app
require 'spec'
require 'spec/interop/test'
require 'rack/test'


set :environment, :test

describe 'The Blank Project' do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application.new
  end

  it "should returns Welcome to the Blank Project" do
    get '/'
    last_response.should be_ok
    #last_response.body.should == 'Welcome to the Blank Project'
  end
  
  it "should list pages"
end