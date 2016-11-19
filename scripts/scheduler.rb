#!/usr/bin/env ruby
# Rufus scheduler
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476
# @reference https://github.com/jmettraux/rufus-scheduler

require File.expand_path('../../config/environment',  __FILE__)
require 'rubygems'
require 'rufus-scheduler'

#Declaring object of type scheduler
scheduler = Rufus::Scheduler.new

#invoking Remind.check_reminder method every 30 seconds
scheduler.every '55s' do
  Remind.check_reminder
end

scheduler.join
