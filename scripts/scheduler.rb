#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'rubygems'
require 'rufus-scheduler'

#Declaring object of type scheduler
scheduler = Rufus::Scheduler.new

#invoking Remind.check_reminder method every 30 seconds
scheduler.every '30s' do
  Remind.check_reminder
end

scheduler.join