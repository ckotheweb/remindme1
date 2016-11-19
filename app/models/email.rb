# Class name: Email
# Version: 0.2
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476

class Email < ApplicationRecord
  belongs_to :profile, optional: true
  has_many :reminds
  validates_uniqueness_of :email
  
  #Search function which queries Email table in db
  def self.search(search_for)
    Email.where("email LIKE ?", "%#{search_for}%") #searching through DB for a particular email address
  end
  
end
