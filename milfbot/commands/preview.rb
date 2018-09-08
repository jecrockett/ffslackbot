require 'milfbot/command_helpers/preview_helper'
require 'pry'

module Milfbot
  module Commands
    class Preview < SlackRubyBot::Commands::Base
      command 'preview', 'projection' do |client, data, match|
        preview(client, data, match[:expression])
      end

      match /^(?<name>.*) detailed preview$/ do |client, data, match|
        preview(client, data, match[:name], detailed: true)
      end

      match /^(?<name>.*) detailed projection$/ do |client, data, match|
        preview(client, data, match[:name], detailed: true)
      end

      match /^(?<name>.*) preview$/ do |client, data, match|
        preview(client, data, match[:name], detailed: false)
      end

      match /^(?<name>.*) projection$/ do |client, data, match|
        preview(client, data, match[:name], detailed: false)
      end

      def self.preview(client, data, name, detailed:)
        helper = Milfbot::CommandHelpers::PreviewHelper.new
        owner = helper.matched_owner_name(name)

        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url ="http://games.espn.com/ffl/matchuppreview?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}"
        page = Nokogiri::HTML(HTTParty.get(url))

        team1 = page.css('table#playertable_0').first
        team2 = page.css('table#playertable_1').first
        team1_name = team1.css('th').first.text
        team2_name = team2.css('th').first.text

        message = []
        message << "*#{team1_name}: #{helper.projected_total(team1)}*"
        message << player_projections(helper, team1) if detailed
        message << '' if detailed
        message << "*#{team2_name}: #{helper.projected_total(team2)}*"
        message << player_projections(helper, team2) if detailed
        message << ''
        message << "*Projected Winner: #{helper.projected_winner(team1, team2)}*"

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end

      def self.player_projections(helper, team_table)
        team_table.css('tr').each_with_index.map do |row, index|
          helper.parse_player_projection(row, index)
        end
      end
    end
  end
end
