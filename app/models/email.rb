class Email < ApplicationRecord
  belongs_to :profile, optional: true
  has_many :reminds
  validates_uniqueness_of :email
  
  def self.search(search_for)
    Email.where("email LIKE ?", "%#{search_for}%") #searching through DB for a particular profile_id
  end
  
end
