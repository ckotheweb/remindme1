require 'mail'
class Remind < ApplicationRecord

belongs_to :email
after_create :send_confirmation

def self.get_email(message)
  begin    
    if message.subject.include? "#"
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
    else
      Autoreply.send_no_hash(message)
    end
  rescue ArgumentError
    Autoreply.send_date_missing(message)
  #rescue Exception
  #  Autoreply.bad_delivery(message)
  end
end

def self.check_reminder
  time = Time.now.strftime("%Y-%m-%d %H:%M:00")
  sendnow = Remind.where("schedule <= ?", time).where(:sent => nil)
  sendnow.each do |remind|
    Autoreply.send_reminder(remind)
  end
end

private

  def send_confirmation
    Autoreply.send_confirm(self)
  end
  
end
