class Email < ApplicationRecord
  belongs_to :profile, optional: true
  has_many :reminds
  validates_uniqueness_of :email
end
