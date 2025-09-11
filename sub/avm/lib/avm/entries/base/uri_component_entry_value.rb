# frozen_string_literal: true

require 'eac_config/entry_path'

module Avm
  module Entries
    module Base
      class UriComponentEntryValue
        enable_method_class
        require_sub __FILE__, require_dependency: true

        enable_listable
        lists.add_symbol :option

        common_constructor :entries_provider, :component_entry_path, :options, default: [{}] do
          self.component_entry_path = ::EacConfig::EntryPath.assert(component_entry_path)
          self.options = self.class.lists.option.hash_keys_validate!(options)
        end

        # @return [EacConfig::EntryPath]
        def id_entry_path
          root_entry_path + %w[id]
        end

        # @return [String, nil]
        def result
          url_entry_value || inherited_value || default_value
        end

        # @return [EacConfig::EntryPath]
        def root_entry_path
          component_entry_path[0..-2]
        end

        # @return [String]
        def component
          component_entry_path.last
        end
      end
    end
  end
end
