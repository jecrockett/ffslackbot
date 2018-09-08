require 'milfbot/lib/constants'

module Milfbot
  module CommandHelpers
    class HelperBase
      def matched_owner_name(input)
        Constants::ALIASES.each do |name, aliases|
          # checks if any alias is a substring of the input so that "jake's" correctly identifies 'jake'
          return name if aliases.any? { |a| input.downcase.include?(a) }
        end
      end
    end
  end
end
