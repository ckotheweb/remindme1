require 'mail'
class Remind < ApplicationRecord

belongs_to :email
    
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => ENV['USER_NAME'],
            :password             => ENV['PASSWORD'],
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
            
Mail.defaults do
  delivery_method :smtp, options
end
  
  def self.get_email(message)
    if Email.where(:email => message.from.first).blank?
      Email.create! email: message.from.first
      email_id = Email.find_by_email(message.from.first).id
      Remind.create! title: message.subject, body: message.body.decoded, email_id: email_id
    else
      email_id = Email.find_by_email(message.from.first).id
      Remind.create! title: message.subject, body: message.body.decoded, email_id: email_id, schedule: Time.now
    end
  end
  
end
