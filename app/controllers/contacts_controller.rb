class ContactsController < ApplicationController
	
	def new
		@contact = Contact.new
		render 'home/mail_us'
	end

	def create
		@contact = Contact.new
		if @contact.save
			flash[:notice] = "Thank you for choosing to work with us, we will get back to you within 48hrs"
		else
			redirect_to 'mailto_us'
			flash[:notice] = "Oooops looks like something went wrong, don't panic we are on it"
		end
	end
end
