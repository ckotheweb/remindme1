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
  
  ###########################################################
  ## Below are the methods which sends e-mail to the user ###
  ### based on the condition. Purpose of method is evident ##
  ###                from theirs names.                   ###
  ###########################################################
  def self.send_confirm(details)
    recipient = Email.find_by_id(details.email_id).email
    title = details.title
    Mail.deliver do
      from "RemindMail Service "+ENV['USER_NAME']
      to recipient
      subject 'Reminder has been logged: '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/confirm.html").gsub("details_schedule", details.schedule.strftime("%Y-%m-%d %H:%M"))
      end
    end
  end
  
    def self.send_no_hash(message)
        recipient = message.from.first
        title = message.subject
        Mail.deliver do
          from "RemindMail Service "+ENV['USER_NAME']
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
      from "RemindMail Service "+ENV['USER_NAME']
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
      from "RemindMail Service "+ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/bad_delivery.html")
      end
    end
  end
  
  def self.bad_encoding(message)
    recipient = message.from.first
    title = message.subject
    Mail.deliver do
      from "RemindMail Service "+ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/bad_encoding.html")
      end
    end  
  end
  
  def self.past_date(message)
    recipient = message.from.first
    title = message.subject
    Mail.deliver do
      from "RemindMail Service "+ENV['USER_NAME']
      to recipient
      subject 'Failed to create reminder : '+title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{Rails.root}/app/assets/reminder_templates/past_date.html")
      end
    end  
  end
  
  ##################################################
  ### Method which sends e-mail reminder to user ###
  ##################################################
  def self.send_reminder(remind)
    if Email.exists? id: remind.email_id                          #Checking if email exists in database. If not, delete that reminder.
      recipient = Email.find_by_id(remind.email_id).email
      title = remind.title
      Mail.deliver do
        from "RemindMail Service "+ENV['USER_NAME']
        to recipient
        subject title
        html_part do
          content_type 'text/html; charset=UTF-8'
          body remind.body
        end
      end
      remind.sent = true
      remind.save
    else
      bad_reminder = Remind.find_by_email_id(remind.email_id).id  #Delete reminder with missing email
      Remind.destroy(bad_reminder)
    end
  end
  
end