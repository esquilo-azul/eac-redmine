# frozen_string_literal: true

module Avm
  module Instances
    class Base
      module Install
        INSTALL_SCHEME_DEFAULT_VALUE = 'file'

        common_concern do
          uri_components_entries_values 'install', %w[data_path email groupname]
        end

        def install_data_path_inherited_value_proc(value)
          "#{value}/#{id}"
        end

        def install_groupname_default_value
          read_entry_optional(::Avm::Instances::EntryKeys::INSTALL_USERNAME)
        end

        # @return [String]
        def install_scheme_default_value
          INSTALL_SCHEME_DEFAULT_VALUE
        end
      end
    end
  end
end
