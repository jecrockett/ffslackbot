require 'milfbot/lib/constants'

module Milfbot
  module CommandHelpers
    class HelperBase
      def matched_owner_name(input)
        Constants::ALIASES.each do |name, aliases|
          return name if aliases.include?(input.downcase)
        end
      end
    end
  end
end
