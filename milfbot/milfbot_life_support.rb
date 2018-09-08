require 'HTTParty'

class MilfbotLifeSupport
  def self.ping_heroku
    HTTParty.get('https://fierce-sierra-27507.herokuapp.com/')
  end
end
