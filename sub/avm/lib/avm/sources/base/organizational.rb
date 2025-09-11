# frozen_string_literal: true

module Avm
  module Sources
    class Base
      module Organizational
        DEFAULT_ORGANIZATIONAL = false
        ORGANIZATIONAL_KEY = 'organizational'

        # @return [Boolean]
        def organizational?
          if organizational_entry.found?
            organizational_entry.value.to_bool
          else
            default_organizational
          end
        end

        def organizational_entry
          configuration.entry(ORGANIZATIONAL_KEY)
        end

        # @return [Boolean]
        def default_organizational
          DEFAULT_ORGANIZATIONAL
        end
      end
    end
  end
end
