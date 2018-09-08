require 'require_all'
require 'slack-ruby-bot'
require 'milfbot/app'
require_all 'milfbot/commands'
require 'nokogiri'
require 'httparty'
require 'rufus-scheduler'
require 'milfbot/milfbot_life_support'

Rufus::Scheduler.new.interval '15m' do
  hour = Time.now.strftime('%H')
  sleep_hours = 1..6
  unless sleep_hours.cover?(hour)
    puts "GIVING MILFBOT CPR ON HEROKU..."
    MilfbotLifeSupport.ping_heroku
  end
end
