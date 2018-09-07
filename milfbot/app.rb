# require 'milfbot/command_helpers/helper_base'

module Milfbot
  class App < SlackRubyBot::App
    # command 'ping' do |client, data, match|
    #   client.say(text: 'pong', channel: data.channel)
    # end
    #
    # command 'team' do |client, data, match|
    #   owner = matched_owner_name(match)
    #   team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
    #   url = "http://games.espn.com/ffl/clubhouse?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}&seasonId=#{Constants::ESPN_LEAGUE_YEAR}"
    #   page = Nokogiri::HTML(HTTParty.get(url))
    #   players = page.css('.playertablePlayerName').map { |row| row.text }.join("\n")
    #   client.say(text: players, channel: data.channel)
    # end

    # command 'matchup' do |client, data, match|
    #   owner = matched_owner_name(match)
    #   team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
    #   url ="http://games.espn.com/ffl/matchuppreview?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}"
    #   page = Nokogiri::HTML(HTTParty.get(url))
    #
    #   team1 = page.css('table#playertable_0').first
    #   team1_name = team1.css('th').first.text
    #   team2 = page.css('table#playertable_1').first
    #   team2_name = team2.css('th').first.text
    #
    #   message = []
    #   message << "*#{team1_name}: #{projected_total(team1)}*"
    #   team1.css('tr').each_with_index.map do |row, index|
    #     message << parse_player_projection(row, index)
    #   end
    #   message << ''
    #   message << "*#{team2_name}: #{projected_total(team2)}*"
    #   team2.css('tr').each_with_index.map do |row, index|
    #     message << parse_player_projection(row, index)
    #   end
    #   message << ''
    #   message << "*Projected Winner: #{projected_winner(team1, team2)}*"
    #
    #   client.say(text: message.compact.join("\n"), channel: data.channel)
    # end
    #
    # def self.matched_owner_name(match)
    #   Constants::ALIASES.each do |name, aliases|
    #     return name if aliases.include?(match[:expression].downcase)
    #   end
    # end
    #
    # def self.parse_player_projection(row, index)
    #   "#{row.css('a')[0].text} - Proj: #{row.css('td').last.text}" unless index < 2
    # end
    #
    # def self.projected_total(table)
    #   table.next_sibling.css('div').text
    # end
    #
    # def self.projected_winner(team1_table, team2_table)
    #   if projected_total(team1_table) > projected_total(team2_table)
    #     team1_table.css('th').first.text
    #   elsif projected_total(team1_table) < projected_total(team2_table)
    #     team2_table.css('th').first.text
    #   else
    #     'Tie motherfuckers!'
    #   end
    # end
  end
end
# 
# SlackRubyBot::Client.logger.level = Logger::WARN
#
# Milfbot::App.instance.run
