module Milfbot
  module Commands
    class Scoreboard < SlackRubyBot::Commands::Base
      command 'scoreboard', 'scores' do |client, data, match|
        helper = Milfbot::CommandHelpers::HelperBase.new
        owner = helper.matched_owner_name(name)
        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url = "http://games.espn.com/ffl/scoreboard?leagueId=#{Constants::ESPN_LEAGUE_ID}&seasonId=#{Constants::ESPN_LEAGUE_YEAR}"
        page = Nokogiri::HTML(HTTParty.get(url))

        matchups = page.css('.matchup')
        message = []
        message << '*Live Scores:*'
        matchups.each do |matchup|
          team1 = matchup.css('tr')[0]
          team2 = matchup.css('tr')[1]
          team1_proj = matchup.css('.playersPlayed').first.css('div')[-3].text
          team2_proj = matchup.css('.playersPlayed').last.css('div')[-3].text
          message << "#{team1.css('a').text}: *#{team1.css('td')[-1].text}*   (Proj: #{team1_proj})"
          message << "#{team2.css('a').text}: *#{team2.css('td')[-1].text}*   (Proj: #{team2_proj})"
          message << ''
        end

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
