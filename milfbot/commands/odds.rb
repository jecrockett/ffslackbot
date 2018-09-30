require 'json'

module Milfbot
  module Commands
    class Odds < SlackRubyBot::Commands::Base
      command 'odds' do |client, data, match|
        url = "https://script.google.com/macros/s/AKfycbxxuThpfWY1dZ6Typd9AyeyYlPmCtVUOsCY5qnCPU3npIK-26sT/exec?command=odds"
        response = HTTParty.get(url, format: :plain)
        json = JSON.parse(response, symbolize_names: true)

		odds = []
		json[:owner].flatten().each_with_index do |owner, index|
			odds << {name: owner, odds: json[:odds].flatten()[index]}
		end
    	odds = odds.sort_by {|h| -h[:odds]}

        message = []
        message << '*Playoff Odds:*'
        message << ''
        odds.each do |entry|
          message << "*#{entry[:name]}*: #{(entry[:odds]*100).round(2)}%"
        end

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
