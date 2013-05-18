module ApplicationHelper
	  
	def display_notice
  		flash.each do |key,value|
  			content_tag(:div, :class => "alert")
    	end
    end

    def full_title(page_title)
    	base_title = "Afrails Web design and development Services"
    	if page_title.empty?
    		base_title
    	else
    		"#{base_title} | #{page_title}"
    	end
    end

end
