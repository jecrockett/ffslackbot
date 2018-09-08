class LifeSupport
  def self.ping_heroku
    HTTParty.get('https://fierce-sierra-27507.herokuapp.com/')
  end
end

Rufus::Scheduler.new.interval '15m' do
  hour = Time.now.strftime('%k').to_i
  sleep_hours = 1..6
  unless sleep_hours.cover?(hour)
    puts "GIVING MILFBOT CPR ON HEROKU..."
    LifeSupport.ping_heroku
  end
end
