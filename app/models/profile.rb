class Profile < ApplicationRecord
  belongs_to :user
  has_one :email
  accepts_nested_attributes_for :email
  
end

