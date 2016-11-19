# Class name: Profile
# Version: 0.3
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476

class Profile < ApplicationRecord
  belongs_to :user
  has_one :email
  accepts_nested_attributes_for :email
  
  after_create :check_email
  
  validates :age, length: { maximum: 2 }, presence: true
  validates :name, presence: true
  validates :lastname, presence: true
  
  private
  
  #After profile creation, below method is checking if e-mail already exist in Email table, and if so, updates Foreign Key with a new value (profile.id)
  #This method is required in order to link reminders with account. Here, reminders which were created by e-mails before account/profile is created.
  def check_email
    ex_address = User.find_by_id(self.user_id).email
    if Email.exists?(email: ex_address)
      email_record_id = Email.find_by_email(ex_address).id
      Email.update(email_record_id, :profile_id => self.id)
    else
      email = Email.new({:email => ex_address, :profile_id => self.id})
      email.save
    end
  end
  
end

