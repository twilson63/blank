require 'spec_helper'


describe 'Blank' do
  include Rack::Test::Methods
  
  before(:each) do
    Page.all.each { |p| p.delete }
  end
  
  
  it "says welcome" do

    get '/'
    
    last_response.should be_ok
    last_response.body.should =~ /Blank/
    
  end
  
  it "creates pages" do
    post '/pages?api_key=123456789', :page => { :name => 'sweet', :body => '%h1 Hello World', :page_type => 'haml'}
    Page.all.count.should == 1
    puts Page.first.inspect
    puts Page.first[:created_at]
    puts Page.first[:updated_at]
    
  end
  
  it "says sweet" do
    post '/pages?api_key=123456789', :page => { :name => 'sweet', :body => '%h1 Hello World', :page_type => 'haml'}

    get '/sweet'
    
    last_response.should be_ok
    last_response.body.should =~ /Hello World/
    
  end
  
  it "should update a page" do
    p = Page.create(:name => 'bang', :body => '%h1 Update Me', :page_type => 'haml')
    get '/bang'
    
    last_response.should be_ok
    last_response.body.should =~ /Update Me/
    
    put "/pages/#{p[:id]}?api_key=123456789", :page => { :body => '%h1 Rock and Roll' }
    
    get '/bang'

    last_response.should be_ok
    last_response.body.should =~ /Rock and Roll/
    
    
  end
  
  it "should delete a page" do
    p = Page.create(:name => 'bang', :body => '%h1 Update Me', :page_type => 'haml')

    get '/bang'    
    last_response.should be_ok
    last_response.body.should =~ /Update Me/
    
    delete "/pages/#{p[:id]}?api_key=123456789"
    
    get '/bang'
    
    last_response.should be_ok
    last_response.body.should =~ /Blank/
    
    
  end
  
  it "should list pages" do
    p = Page.create(:name => 'bang', :body => '%h1 Welcome', :page_type => 'haml')

    get '/pages?api_key=123456789'    
    last_response.should be_ok
    Crack::JSON.parse(last_response.body).length == 1
    
  end
  
  it "should not be authorized" do
    get '/pages'
    
    last_response.body.should =~ /Not Authorized/
  end
  
  
  
  
end
