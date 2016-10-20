class Remind < ApplicationRecord

belongs_to :email
validate :date_cannot_be_in_the_past, :on => :create                              #Validating that date cannot be past only on create. When updating record - it won't require
after_create :send_confirmation                                                   #Invoke method send_confirmation after reminder is created.

#Method checks if date and time are not less than current time.
def date_cannot_be_in_the_past
  errors.add(:schedule, "must be higher or equal to today") if !schedule.blank? && schedule < Time.now
end

def self.get_email(message)
  timezone = "+0100" #Set correct timezone for you region. Dublin Summer = +0100, Diblin Winter = +0000. Also tz shall be changed under /etc/timezone and under config/application.rb
  #Declaring dates variables for logging date of reminder using word notation instead of digits.
  today = Date.today.to_s+" "
  tomorrow = (Date.today + 1.day).to_s+" "
  nextweek = (Date.today + 1.week).to_s+" "
  nextmonth = (Date.today + 1.month).to_s+" "
  nextyear = (Date.today + 1.year).to_s+" "
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
        sched_non_converted = (today + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      elsif message.subject.partition('#').first.downcase.include? "tomorrow"
        sched_non_converted = (tomorrow + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      elsif message.subject.partition('#').first.downcase.include? "week"
        sched_non_converted = (nextweek + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      elsif message.subject.partition('#').first.downcase.include? "month"
        sched_non_converted = (nextmonth + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      elsif message.subject.partition('#').first.downcase.include? "year"
        sched_non_converted = (nextyear + time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      else
        digitaldate = message.subject.partition('#').first.to_datetime.strftime("%Y-%m-%d").to_s
        sched_non_converted = (digitaldate+" "+time_sched).to_datetime
        sched_arg = sched_non_converted.change(:offset => timezone)
      end
      
      #Calling logreminder method if no exceptions have been occured
      logreminder(message, title_arg, sched_arg)
        
    else
      Autoreply.send_no_hash(message)
    end
  #rescue ArgumentError
   # Autoreply.send_date_missing(message)
  rescue Encoding::UndefinedConversionError
    Autoreply.bad_encoding(message)
  #rescue Exception
  #  Autoreply.bad_delivery(message)
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
    Autoreply.send_confirm(self)
  end
  
end