module Milfbot
  module Commands
    class Standings < SlackRubyBot::Commands::Base
      command 'standings' do |client, data, match|
        url = "http://games.espn.com/ffl/standings?leagueId=#{Constants::ESPN_LEAGUE_ID}&seasonId=#{Constants::ESPN_LEAGUE_YEAR}"
        page = Nokogiri::HTML(HTTParty.get(url))

        divs = page.css('table.tableBody')[0..1]
        message = []
        divs.each do |div|
          name = div.css('tr.tableHead').text.downcase.split.map(&:capitalize).join(' ')
          message << "*#{name}:*"
          teams = div.css('tr.tableBody')
          teams.each do |team|
            columns = team.css('td')
            line = ''
            line << "#{columns.first.text}: "
            columns[1..3].each do |column|
              line << "#{column.text}-"
            end
            message << line[0...-1]
          end
          message << ''
        end
        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
