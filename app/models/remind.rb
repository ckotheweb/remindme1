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
    sched_arg = message.subject.partition('#').first.to_datetime
    title_arg = message.subject.partition('#').last
      
    if Email.where(:email => message.from.first).blank?
      Email.create! email: message.from.first
      email_id = Email.find_by_email(message.from.first).id
      Remind.create! title: message.subject, body: message.body.decoded, email_id: email_id
    else
      email_id = Email.find_by_email(message.from.first).id
      Remind.create! title: title_arg, body: message.html_part.body.decoded, email_id: email_id, schedule: sched_arg
    end
  end
  
  after_create :send_confirm
  
  private
  
  def send_confirm
    recipient = Email.find_by_id(self.email_id).email
    title = self.title
    Mail.deliver do
      to recipient
      from ENV['USER_NAME']
      subject 'Reminder has been logged: '+title
      body 'Thank you for using Reminder Service!'
    end
  end
  
end
