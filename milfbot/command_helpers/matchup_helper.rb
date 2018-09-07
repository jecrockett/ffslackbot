require_relative 'helper_base'

module Milfbot
  module CommandHelpers
    class MatchupHelper < HelperBase
      def parse_player_projection(row, index)
        "#{row.css('a')[0].text} - Proj: #{row.css('td').last.text}" unless index < 2
      end

      def projected_total(table)
        table.next_sibling.css('div').text
      end

      def projected_winner(team1_table, team2_table)
        if projected_total(team1_table) > projected_total(team2_table)
          team1_table.css('th').first.text
        elsif projected_total(team1_table) < projected_total(team2_table)
          team2_table.css('th').first.text
        else
          'Tie motherfuckers!'
        end
      end
    end
  end
end
