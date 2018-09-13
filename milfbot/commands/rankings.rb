module Milfbot
  module Commands
    class Rankings < SlackRubyBot::Commands::Base
      command 'rankings' do |client, data, match|
        url = "https://script.google.com/macros/s/AKfycbxxuThpfWY1dZ6Typd9AyeyYlPmCtVUOsCY5qnCPU3npIK-26sT/exec?command=ranks"
        response = HTTParty.get(url, format: :plain)
        JSON.parse response, symbolize_names: true

        owners = eval(response)[:owner]
        ranks = eval(response)[:ranks]
        message = []
        message << '*Power Rankings:*'
        message << ''
        i = 0
        owners.each do |owner|
          message << "*#{owner[0]}*: ##{ranks[i][0]}"
          i += 1
        end

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end