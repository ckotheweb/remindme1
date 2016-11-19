# Class name: User
# Version: 0.2
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476

class User < ApplicationRecord
  #Relation. User has one profile. When user account is deleted, profiles is deleted as well. 
  has_one :profile, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  
  #Making current_user to be available in all model classes.
  # @reference http://stackoverflow.com/questions/2513383/access-current-user-in-model
  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
end
