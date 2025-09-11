# frozen_string_literal: true

module Avm
  module Entries
    class Entry
      class NoContextEntry
        def found?
          false
        end

        def value
          nil
        end

        def value!
          raise('No context entry - there is no value')
        end
      end
    end
  end
end
