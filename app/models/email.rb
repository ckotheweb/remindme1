class Email < ApplicationRecord
  belongs_to :profile
  has_many :reminds
  validates_uniqueness_of :email
end
