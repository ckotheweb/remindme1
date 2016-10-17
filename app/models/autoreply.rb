require 'mail'
class Autoreply < Remind
    
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => ENV['USER_NAME'],
            :password             => ENV['PASSWORD'],
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
            
Mail.defaults do
  delivery_method :smtp, options
end
  
  def self.send_confirm(details)
    recipient = Email.find_by_id(details.email_id).email
    title = details.title
    Mail.deliver do
      from ENV['USER_NAME']
      to recipient
      subject 'Reminder has been logged: '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/confirm.html")
      end
    end
  end
  
    def self.send_no_hash(message)
        recipient = message.from.first
        title = message.subject
        Mail.deliver do
          from ENV['USER_NAME']
          to recipient
          subject 'Failed to create reminder : '+title
          html_part do
            content_type 'text/html; charset=UTF-8'
            body File.read("#{Rails.root}/app/assets/reminder_templates/error_hash.html")
          end
        end
    end
  
  def self.send_no_hash(message)
    recipient = message.from.first
    title = message.subject
    Mail.deliver do
      from ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/error_hash.html")
      end
    end
  end
  
  def self.send_date_missing(message)
    recipient = message.from.first
    title = message.subject
    Mail.deliver do
      from ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/error_date.html")
      end
    end
  end
  
  def self.bad_delivery(message)
    recipient = message.from.first
    title = message.subject
    Mail.deliver do
      from ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/bad_delivery.html")
      end
    end
  end
  
  def self.send_reminder(remind)
    recipient = Email.find_by_id(remind.email_id).email
    title = remind.title
    Mail.deliver do
      from ENV['USER_NAME']
      to recipient
      subject title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body remind.body
      end
    end
    remind.sent = true
    remind.save
  end
  
end