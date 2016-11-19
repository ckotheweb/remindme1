#!/usr/bin/env ruby
# Mailman server
# Date 2016/10
# @reference http://blog.emiketic.com/web/2015/05/14/receive-emails-rails.html

require File.expand_path('../../config/environment',  __FILE__)
require "rubygems"
require "bundler/setup"
require "mailman"
require "my_logger"
#POP3 Polling interval
Mailman.config.poll_interval = 30

#Mail client config
Mailman.config.pop3 = {
    username:  ENV["USER_NAME"],
    password:  ENV["PASSWORD"],
    server: 'pop.gmail.com',
    port: 995, # defaults to 110
    ssl: true # defaults to false
}

#When e-mail received calls Remind.get_mail method and is passing arguments into it.
Mailman::Application.run do
    default do
        begin
            Remind.get_email(message)
	###Exceptions handling and logging if mailman fails to check for incoming e-mail
        rescue Exception => e
      	  Mailman.logger.error "Exception occurred while receiving message:n#{message}"
      	  Mailman.logger.error [e, *e.backtrace].join("n")
        end
    end
end
