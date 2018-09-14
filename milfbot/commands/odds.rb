require 'json'

module Milfbot
  module Commands
    class Odds < SlackRubyBot::Commands::Base
      command 'odds' do |client, data, match|
        url = "https://script.google.com/macros/s/AKfycbxxuThpfWY1dZ6Typd9AyeyYlPmCtVUOsCY5qnCPU3npIK-26sT/exec?command=odds"
        response = HTTParty.get(url, format: :plain)
        JSON.parse response, symbolize_names: true

        owners = eval(response)[:owner]
        odds = eval(response)[:odds]
        message = []
        message << '*Playoff Odds:*'
        message << ''
        i = 0
        owners.each do |owner|
          message << "*#{owner[0]}*: #{(odds[i][0]*100).round(2)}%"
          i += 1
        end

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
