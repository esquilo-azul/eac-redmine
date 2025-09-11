# frozen_string_literal: true

module Avm
  module Applications
    class Base
      module Naming
        DEFAULT_NAME = '_Undefined_'

        # @return [String]
        def default_name
          DEFAULT_NAME
        end

        # @return [String]
        def name
          name_from_configuration || default_name
        end

        # @return [String]
        def name_from_configuration
          entry(::Avm::Instances::EntryKeys::NAME).optional_value
        end
      end
    end
  end
end
