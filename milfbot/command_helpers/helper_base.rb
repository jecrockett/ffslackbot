require 'milfbot/lib/constants'

module Milfbot
  module CommandHelpers
    class HelperBase
      def matched_owner_name(match)
        Constants::ALIASES.each do |name, aliases|
          return name if aliases.include?(match[:expression].downcase)
        end
      end
    end
  end
end
