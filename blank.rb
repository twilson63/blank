
require 'json'
require 'activerecord'

Dir.glob(File.join(File.dirname(__FILE__), 'models/*.rb')).each {|f| require f }


dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

### Page Controller
get '/pages' do
  Page.all.to_json
end

post '/pages' do
  Page.create!(params["page"]).to_json if valid_key?(params["api_key"])
end

get '/pages/*' do
  Page.get_page(params["splat"].to_s).to_json 
end

# update 
put '/pages/:id' do
  Page.find(params[:id]).update_attributes(params[:page]).to_json if valid_key?(params["api_key"])
end

delete '/pages/:id' do
  Page.find(params[:id]).destroy if valid_key?(params["api_key"])
  ""
end

### Front End
get '/*' do
  @title = "Home"
  body = :index
  my_layout = :layout

  @page = Page.get_page(params["splat"].to_s)
  if @page
    @title = @page.name.camelize
    my_layout = Page.find_by_name('layout').body
    body = @page.body
  else
    body = Page.find_by_name('index').body if Page.find_by_name('index')
    my_layout = Page.find_by_name('layout').body if Page.find_by_name('index')
  end
  haml body, :layout => my_layout
end


def valid_key?(api_key)
  configkey = ENV['API_KEY']
  # puts "#{api_key} == #{configkey}"
  api_key == configkey
  
end

__END__

@@ layout
%html
  %body
    = yield
    
@@ index
%div.title Welcome to the Blank Project
%br
%a{:href => "http://github.com/twilson63/blank"} The Blank Project Home Page 


