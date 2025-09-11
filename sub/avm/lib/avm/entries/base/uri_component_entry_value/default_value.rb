# frozen_string_literal: true

require 'eac_config/entry_path'

module Avm
  module Entries
    module Base
      class UriComponentEntryValue
        class DefaultValue
          enable_method_class
          common_constructor :uri_component_entry_value
          delegate :component_entry_path, :entries_provider, to: :uri_component_entry_value

          # @return [Symbol]
          def default_value_method_name
            component_entry_path.default_method_name
          end

          def result
            entries_provider.if_respond(default_value_method_name)
          end
        end
      end
    end
  end
end
