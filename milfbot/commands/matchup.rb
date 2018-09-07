module Milfbot
  module Commands
    class Milfbot::Commands::Matchup < SlackRubyBot::Commands::Base
      command 'matchup' do |client, data, match|
        owner = matched_owner_name(match)
        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url ="http://games.espn.com/ffl/matchuppreview?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}"
        page = Nokogiri::HTML(HTTParty.get(url))

        team1 = page.css('table#playertable_0').first
        team1_name = team1.css('th').first.text
        team2 = page.css('table#playertable_1').first
        team2_name = team2.css('th').first.text

        message = []
        message << "*#{team1_name}: #{projected_total(team1)}*"
        team1.css('tr').each_with_index.map do |row, index|
          message << parse_player_projection(row, index)
        end
        message << ''
        message << "*#{team2_name}: #{projected_total(team2)}*"
        team2.css('tr').each_with_index.map do |row, index|
          message << parse_player_projection(row, index)
        end
        message << ''
        message << "*Projected Winner: #{projected_winner(team1, team2)}*"

        client.say(text: message.compact.join("\n"), channel: data.channel)
      end
    end
  end
end
