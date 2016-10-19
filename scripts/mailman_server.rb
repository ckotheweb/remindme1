#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require "rubygems"
require "bundler/setup"
require "mailman"

Mailman.config.pop3 = {
    username:  ENV["USER_NAME"],
    password:  ENV["PASSWORD"],
    #password: "gmokmxhbwopcjoqz",
    server: 'pop.gmail.com',
    port: 995, # defaults to 110
    ssl: true # defaults to false
}

Mailman::Application.run do
    default do
        Remind.get_email(message)
    end
end
