class Page < ActiveRecord::Base
  def self.get_page(request)
   ## Parse url and get last element
   Page.find_by_name(request)
  end
  
  def body
    if ENV['ASSET_URL']
      self.body.replace('/images', ENV['ASSET_URL'] + '/images')
    else
      self.body
    end
  end
end