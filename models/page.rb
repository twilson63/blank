require 'rdiscount'

class Page < ActiveRecord::Base
  def self.get_page(request)
   ## Parse url and get last element
   Page.find_by_name(request)
  end
  
  def body
    if self.page_type == "markdown"
      RDiscount.new(self.body).to_html       
    else
      self.body
    end
  end
  
end