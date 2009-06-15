require 'spec/spec_helper'


describe "test spec form helpers" do
  it "should use a helper to make cookies" do
    request = mock("request")
    response = mock("response", :body= => nil)
    route_params = mock("route_params")
    @event_context = Sinatra::Default.new(request, response, route_params)
    
    @event_context.link("Hello", "http://www.google.com").should == "<a href='http://www.google.com'>Hello</a>"
  end
end
# describe 'The Blank Kit' do
#   include Rack::Test::Methods
#   
#   it "says welcome" do
#     #@haml = mock("hello")
# 
#     #app.any_instance.expects( :haml ).returns( @haml )
# 
#     get '/'
#     
#     last_response.should be_ok
#     last_response.body.should == 'hello'
#     #last_response.body.include?('Welcome to the Blank Project').should be_true
#     
#   end
# end
