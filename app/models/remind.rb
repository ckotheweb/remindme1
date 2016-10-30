require 'my_logger'

class Remind < ApplicationRecord

belongs_to :email
validate :date_cannot_be_in_the_past                                             #Validating that date cannot be past only on create. When updating record - it won't require
after_create :send_confirmation                                                   #Invoke method send_confirmation after reminder is created.

#Method checks if date and time are not less than current time.
def date_cannot_be_in_the_past
  errors.add(:schedule, "must be higher or equal to today") if !schedule.blank? && schedule < Time.now
end

def self.get_email(message)
  #If statement for getting user's timezone and setting appropriate time based on it
  if (Email.exists? email: message.from.first) && (Profile.exists? id: Email.find_by_email(message.from.first).profile_id)
    tz = Profile.find_by_id(Email.find_by_email(message.from.first).profile_id).timezone
  else
    tz = "UTC"
  end
  timezone = Time.now.in_time_zone(tz).strftime('%z')
  #Declaring dates variables for logging date of reminder using word notation instead of digits.
  Time.zone = tz
  today = Time.now.in_time_zone(tz).to_date
  #today = Date.today.to_s+" "
  today_s = today.to_s+" "
  tomorrow = (today + 1.day).to_s+" "
  nextweek = (today + 1.week).to_s+" "
  nextmonth = (today + 1.month).to_s+" "
  nextyear = (today + 1.year).to_s+" "
  begin
    title_arg = message.subject.partition('#').last
    if message.subject.include? "#"                                               #Verifying hash delimiter is in the subject
      timeparse = message.subject.partition('#').first
      if timeparse.include? "."                                                   #Verifying time delimiter. If between hour and minute is dot ".", replace it with colon ":"
        timeparse.gsub!('.', ':')
      end
      #Converting extracted time to readable for app format
      time_non_converted = timeparse.to_datetime
      time_sched = time_non_converted.strftime("%H:%M:00")
      
      #getting reminder date from word notation, or, in final, from digital notation.
      if message.subject.partition('#').first.downcase.include? "today"
        sched_non_converted = (today_s + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      elsif message.subject.partition('#').first.downcase.include? "tomorrow"
        sched_non_converted = (tomorrow + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      elsif message.subject.partition('#').first.downcase.include? "week"
        sched_non_converted = (nextweek + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      elsif message.subject.partition('#').first.downcase.include? "month"
        sched_non_converted = (nextmonth + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      elsif message.subject.partition('#').first.downcase.include? "year"
        sched_non_converted = (nextyear + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      else
        digitaldate = message.subject.partition('#').first.to_datetime.to_s
        sched_non_converted = (digitaldate+" "+time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => -timezone)
      end
      
      #Calling logreminder method if no exceptions have been occured
      logreminder(message, title_arg, sched_arg)
        
    else
      Autoreply.send_no_hash(message)
    end
  ##################################################
  ############# Rescuing exceptions ################
  ##################################################
  rescue ArgumentError
    Autoreply.send_date_missing(message)
  rescue Encoding::UndefinedConversionError
    Autoreply.bad_encoding(message)
  rescue Exception => error_message
    Autoreply.bad_delivery(message)
    ################################################
    ## Logger to log unknown unhandled exceptions ##
    ################################################
    catch_log = MyLogger.instance
    catch_log.logException("NEW ERROR LOGGED! - " + Time.now.to_s)
    catch_log.logException("#################---------------------################")
    catch_log.logException(error_message)
    catch_log.logException("######################################################")
    
  end
end

#Reminders check method which checks what reminders have to be processed right now.
def self.check_reminder
  time = Time.now.strftime("%Y-%m-%d %H:%M:00")
  sendnow = Remind.where("schedule <= ?", time).where(:sent => nil) #Find reminders where scheduled time is less then current time and which weren't sent before.
  sendnow.each do |remind|
    Autoreply.send_reminder(remind)
#    no_email_reminder = Remind.where("schedule <= ?", time).where(!Email.exists?(id: remind.email_id))  #Sanity check
#    reminder_to_delete = Remind.find_by_email_id(no_email_reminder.id).id
#    Remind.destroy(reminder_to_delete)
  end
end

private
#Reminders logging method which is called from get_email method
def self.logreminder(message, title_arg, sched_arg)
    begin
      if Email.where(:email => message.from.first).blank?
        Email.create! email: message.from.first
        email_id = Email.find_by_email(message.from.first).id
        Remind.create! title: title_arg, body: message.html_part.body.decoded, email_id: email_id, schedule: sched_arg
      else
        email_id = Email.find_by_email(message.from.first).id
        Remind.create! title: title_arg, body: message.html_part.body.decoded, email_id: email_id, schedule: sched_arg
      end
    rescue ActiveRecord::RecordInvalid
      Autoreply.past_date(message)
    end
end

  def send_confirmation
    if User.current == nil          #Send confirmation only when user is not logged-on
      Autoreply.send_confirm(self)
    end
  end
  
end