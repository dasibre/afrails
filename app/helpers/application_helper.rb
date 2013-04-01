module ApplicationHelper
	  
	def display_notice
  		flash.each do |key,value|
  		content_tag(:div, :class => "alert")
  	end
  end
end
