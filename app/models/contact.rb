class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name, :phone
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

  VALID_PHONE_REGEX = /[0-9]{3}-[0-9]{3}-[0-9]{4}/i
  validates :name, :message, :presence => { :message  => "*This field is required" }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {  case_sensitive: false }
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX, :message => "Phone format xxx-xxx-xxxx" }

  
  def self.find_all_ordered
      find(:all, :order => 'Name, email, message')
  end
end
