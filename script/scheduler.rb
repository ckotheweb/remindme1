#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '15s' do
  Remind.check_reminder
end

scheduler.join