require 'rdiscount'

class Page < ActiveRecord::Base
  def self.get_page(request)
   ## Parse url and get last element
   Page.find_by_name(request)
  end  
end