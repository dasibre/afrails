class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name, :phone

  validates :name, :email, :phone, :message, :presence => { :message  => "*This field is required" }
end
