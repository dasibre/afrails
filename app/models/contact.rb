class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name, :phone
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :name, :phone, :message, :presence => { :message  => "*This field is required" }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {  case_sensitive: false }
  
  def self.find_all_ordered
      find(:all, :order => 'Name, email, message')
  end
end
