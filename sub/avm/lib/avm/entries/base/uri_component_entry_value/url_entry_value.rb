# frozen_string_literal: true

require 'eac_config/entry_path'

module Avm
  module Entries
    module Base
      class UriComponentEntryValue
        class UrlEntryValue
          enable_method_class
          common_constructor :uri_component_entry_value
          delegate :component, :entries_provider, :root_entry_path, to: :uri_component_entry_value

          def result
            return unless url_entry.context_found?

            ::Avm::Entries::UriBuilder.from_source(url_entry.value.to_uri)
              .avm_field_get(component)
          end

          # @return [Avm::Entries::Entry]
          def url_entry
            entries_provider.entry((root_entry_path + %w[url]).to_string)
          end
        end
      end
    end
  end
end
