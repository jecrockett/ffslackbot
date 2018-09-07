require 'sinatra/base'

class Milfbot::Web < Sinatra::Base
  get '/' do
    'Fantasy football is life'
  end
end
