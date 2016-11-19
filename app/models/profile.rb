class Profile < ApplicationRecord
  belongs_to :user
  has_one :email
  accepts_nested_attributes_for :email
  
  after_create :check_email
  
  validates :age, length: { maximum: 2 }, presence: true
  validates :name, presence: true
  validates :lastname, presence: true
  
  private
  
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

