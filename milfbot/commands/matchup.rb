module Milfbot
  module Commands
    class Matchup < SlackRubyBot::Commands::Base
      command 'matchup', 'score' do |client, data, match|
        matchup(client, data, match[:expression])
      end

      match /^(?<name>.*) detailed matchup$/ do |client, data, match|
        matchup(client, data, match[:name], detailed: true)
      end

      match /^(?<name>.*) detailed score$/ do |client, data, match|
        matchup(client, data, match[:name], detailed: true)
      end

      match /^(?<name>.*) matchup$/ do |client, data, match|
        matchup(client, data, match[:name], detailed: false)
      end

      match /^(?<name>.*) score$/ do |client, data, match|
        matchup(client, data, match[:name], detailed: false)
      end

      def self.matchup(client, data, name, detailed:)
        helper = Milfbot::CommandHelpers::HelperBase.new
        owner = helper.matched_owner_name(name)
        team_id = Constants::ESPN_TEAM_IDS_BY_OWNER[owner]
        url = "http://games.espn.com/ffl/boxscorequick?leagueId=#{Constants::ESPN_LEAGUE_ID}&teamId=#{team_id}&seasonId=2018"
        page = Nokogiri::HTML(HTTParty.get(url))

        team1_projected = page.css('.games-alert-mod').first.css('span')[-1].text
        team2_projected = page.css('.games-alert-mod').last.css('span')[-1].text
        team1_score = page.css('.danglerBox')[0].text
        team2_score = page.css('.danglerBox')[2].text
        team1 = page.css('table#playertable_0')
        team2 = page.css('table#playertable_2')
        team1_name = team1.css('.playertableTableHeader').text.sub('Box Score', '')
        team2_name = team2.css('.playertableTableHeader').text.sub('Box Score', '')

        message = []
        message << '*Live Scores:*'
        message << "#{team1_name}: *#{team1_score}*   (Proj: #{team1_projected})"
        message << player_scores(team1) if detailed
        message << '' if detailed
        message << "#{team2_name}: *#{team2_score}*   (Proj: #{team2_projected})"
        message << player_scores(team2) if detailed

        client.say(text: message.flatten.compact.join("\n"), channel: data.channel)
      end

      def self.player_scores(team_table)
        team_table.css('.pncPlayerRow').reverse.each_with_index.map do |row, index|
          "#{row.css('a')[0].text}: *#{row.css('td').last.text}*"
        end
      end
    end
  end
end
