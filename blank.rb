require 'sinatra'
require 'haml'
require 'rdiscount'
require 'json'
require 'sequel'
require 'sequel/extensions/migration'

require 'crack'
require 'active_support'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://pages.db')

class CreatePages < Sequel::Migration
  def up
    create_table(:pages) do
      primary_key :id
      String :name
      Text :body
      Integer :page_id
      String :page_type

      timestamp :created_at
      timestamp :updated_at
       
    end
    
  end

  def down
    drop_table(:pages)
  end
end

CreatePages.apply(DB, :up) unless DB.tables.include?(:pages)

class Page < Sequel::Model
end

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
  Page.create(params["page"]).to_json
end

## Show
get '/pages/*' do
  Page.where(:name => params["splat"].to_s).first.to_json
end

# update 
put '/pages/:id' do
  Page[params[:id]].update(params[:page]).to_json 
end

# delete 
delete '/pages/:id' do
  Page[params[:id]].delete
  ""
end

### Front End
get '/*' do
  @page = Page.where(:name => params["splat"].to_s).first || Page.where(:name => 'index').first
  if @page
    @title = @page[:name].camelize
    if Page.where(:name => 'layout').count > 0
      my_layout = Page.where(:name => 'layout').first[:body]
    end
    body = get_body(@page)
  end

  haml body || :index, :layout => my_layout || :layout
end


def get_body(page)
  if page[:page_type] == "markdown"
    RDiscount.new(page[:body]).to_html       
  else
    page[:body]
  end  
end

def key_required
  throw :halt, [403, "Not Authorized"] unless valid_key?(params[:api_key])
end


def valid_key?(api_key)
  api_key == (ENV['API_KEY'] || "123456789") 
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


