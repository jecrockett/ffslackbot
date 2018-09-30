require 'json'

module Milfbot
  module Commands
    class Rankings < SlackRubyBot::Commands::Base
      command 'rankings' do |client, data, match|
        url = "https://script.google.com/macros/s/AKfycbxxuThpfWY1dZ6Typd9AyeyYlPmCtVUOsCY5qnCPU3npIK-26sT/exec?command=ranks"
        response = HTTParty.get(url, format: :plain)
        json = JSON.parse response, symbolize_names: true

        owners = json[:owner].flatten()
        ranks = json[:ranks].flatten()
        message = []
        message << '*Power Rankings:*'
        message << ''
        owners.each_with_index do |owner,index|
          message << "*#{owner}*: ##{ranks[index]}"
        end

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
