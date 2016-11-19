#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require "rubygems"
require "bundler/setup"
require "mailman"
#POP3 Polling interval
Mailman.config.poll_interval = 20

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
        Remind.get_email(message)
    end
end
