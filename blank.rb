require 'sinatra'
require 'haml'
require 'rdiscount'
require 'json'
require 'activerecord'
require 'crack'
require 'rest_client'
require 'cgi'

dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

class Page < ActiveRecord::Base
end

# use Rack::Auth::Basic do |username, password|
#   username == 'admin' && password == 'secret'
# end


before do
  if request.path_info.include?('pages')
    key_required
  else 
    @asset_url = ENV['ASSET_URL'] || ""
  end
  
end



### Page Controller

## Index
get '/pages' do
  Page.all.to_json
end

## Create
post '/pages' do
  Page.create!(params["page"]).to_json
end

## Show
get '/pages/*' do
  Page.find_by_name(params["splat"].to_s).to_json
end

# update 
put '/pages/:id' do
  Page.find(params[:id]).update_attributes(params[:page]).to_json 
end

# delete 
delete '/pages/:id' do
  Page.find(params[:id]).destroy
  ""
end

### Front End
get '/*' do

  @title = "index"
  body = :index
  my_layout = :layout

  @page = Page.find_by_name(params["splat"].to_s) || Page.find_by_name('index')
  if @page
    @title = @page.name.camelize
    my_layout = Page.find_by_name('layout').body
    body = get_body(@page)
  end

  haml body, :layout => my_layout
end


def get_body(page)
  if page.page_type == "markdown"
    RDiscount.new(page.body).to_html       
  else
    page.body
  end  
end

def key_required
  throw :halt, [403, "Not Authorized"] unless valid_key?(params[:api_key])
end


def valid_key?(api_key)
  if ENV['API_KEY']
    configkey = ENV['API_KEY']
    # puts "#{api_key} == #{configkey}"
    api_key == configkey
  else
    true
  end
  
end

template :index do
  <<-INDEX
%div.title Welcome to the Blank Project
%br
%a{:href => "http://github.com/twilson63/blank"} The Blank Project Home Page   
  INDEX
end

template :layout do
  <<-LAYOUT
%html
  %body
    = yield
  
  LAYOUT
end


