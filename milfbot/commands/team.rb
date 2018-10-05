require 'milfbot/command_helpers/helper_base'

module Milfbot
  module Commands
    class Team < SlackRubyBot::Commands::Base
      command 'team', 'roster' do |client, data, match|
        team(client, data, match[:expression])
      end

      match /^(?<name>.*) roster$/ do |client, data, match|
        team(client, data, match[:name])
      end

      match /^(?<name>.*) team$/ do |client, data, match|
        team(client, data, match[:name])
      end

      def self.team(client, data, name)
        helper = Milfbot::CommandHelpers::HelperBase.new
        owner = helper.matched_owner_name(name)
        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url = "http://games.espn.com/ffl/clubhouse?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}&seasonId=#{Constants::ESPN_LEAGUE_YEAR}"
        page = Nokogiri::HTML(HTTParty.get(url))
        players = page.css('.playertablePlayerName').map { |row| row.text }.join("\n")
        client.say(text: players, channel: data.channel)
      end
    end
  end
end
