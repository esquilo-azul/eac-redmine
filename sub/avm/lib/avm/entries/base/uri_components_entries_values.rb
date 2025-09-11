# frozen_string_literal: true

module Avm
  module Entries
    module Base
      class UriComponentsEntriesValues
        common_constructor :entries_provider_class, :prefix, :extra_fields

        ENTRIES_FIELDS = ::Avm::Entries::UriBuilder::ENTRIES_FIELDS + %w[url]

        def fields
          ENTRIES_FIELDS + extra_fields
        end

        def result
          fields.map { |field| component_factory(field).setup }
        end

        require_sub __FILE__, require_mode: :kernel
      end
    end
  end
end
