require 'milfbot/command_helpers/helper_base'

module Milfbot
  module Commands
    class Matchup < SlackRubyBot::Commands::Base
      command 'team' do |client, data, match|
        helper = Milfbot::CommandHelpers::HelperBase.new

        owner = helper.matched_owner_name(match[:expression])
        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url = "http://games.espn.com/ffl/clubhouse?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}&seasonId=#{Constants::ESPN_LEAGUE_YEAR}"
        page = Nokogiri::HTML(HTTParty.get(url))
        players = page.css('.playertablePlayerName').map { |row| row.text }.join("\n")
        client.say(text: players, channel: data.channel)
      end
    end
  end
end
