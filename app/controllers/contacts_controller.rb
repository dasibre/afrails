class ContactsController < ApplicationController
	
	def new
		@contact = Contact.new
		render 'home/mail_us'
	end

	def create
		@contact = Contact.new(params[:contact])
		if @contact.save
			redirect_to '/'
			flash.now[:notice] = "Thank you for choosing to work with us, we will get back to you within 48hrs"

		else
			render 'new'
			flash[:notice] = "Oooops looks like something went wrong, don't panic we are on it"
		end
	end
end
