# frozen_string_literal: true

module Avm
  module Sources
    class Base
      module Parent
        # @return [Avm::Sources::Base]
        def parent_by_option
          options[OPTION_PARENT]
        end

        # @return [Avm::Sources::Base]
        def parent_by_search
          ::Avm::Registry.sources.detect_by_path_optional(path.parent)
        end

        private

        # @return [Avm::Sources::Base]
        def parent_uncached
          parent_by_option || parent_by_search
        end
      end
    end
  end
end
