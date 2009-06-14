helpers do
  def label(obj,field, options={})
    tag :label, field.to_s.titleize, options.merge(:for => "#{obj}_#{field}")
  end
  
  def text(obj, field, options={})
    content = @params[obj] ? @params[obj][field.to_s] : ""       
    single_tag :input, options.merge(:type => "text", :id => "#{obj}_#{field}", :name => "#{obj}[#{field}]", :value => content)
  end
  
  def area(obj, field, options={})
    content = @params[obj] ? @params[obj][field.to_s] : ""        
    tag :textarea, content, options.merge(:id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")
  end
  
  def image(src, options={})
    single_tag :img, options.merge(:src => src)
  end
  
  def submit(obj, value, options={})
    single_tag :input, options.merge(:type => "submit", :value => value)
    
  end
  
  def checkbox(obj, field, options={})
    single_tag :input, options.merge(:type => "checkbox", :id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")
    
  end
  
  def radio(obj, field, value, options={})
    content = @params[obj] && @params[obj][field.to_s] == value ? "true" : ""       
    tag :input, value, options.merge(:type => "radio", :id => "#{obj}_#{field}", :name => "#{obj}[#{field}]", :value => value, :checked => content)
    
  end
  
  def select(obj, field, items, option={})
    content = ""
    items.each do |i|
      content = content + tag(:option, i, { :value => i })
    end
    tag :select, content, options
  end
  
  
  # standard open and close tags
  # EX : tag :h1, "shizam", :title => "shizam"
  # => <h1 title="shizam">shizam</h1>
  def tag(name,content,options={})
    with_opts = "<#{name.to_s} #{options.to_html_attrs}>#{content}</#{name}>"
    no_opts = "<#{name.to_s}>#{content}</#{name}>"
    options.blank? ? no_opts : with_opts
  end
  
  # standard single closing tags
  # single_tag :img, :src => "images/google.jpg"
  # => <img src="images/google.jpg" />
  def single_tag(name,options={})
    options ||= options.stringify_keys
    "<#{name.to_s} #{options.to_html_attrs} />"
  end 
  
end
