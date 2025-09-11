# frozen_string_literal: true

require 'addressable'

module Avm
  module Instances
    class Base
      module Production
        DEFAULT_PRODUCTION = true
        PRODUCTION_KEY = 'production'

        # @return [Boolean]
        def default_production?
          DEFAULT_PRODUCTION
        end

        # @return [Boolean]
        def production?
          if production_entry.found?
            production_entry.value.to_bool
          else
            default_production?
          end
        end

        # @return [Avm::Entries::Entry]
        def production_entry
          entry(PRODUCTION_KEY)
        end
      end
    end
  end
end
