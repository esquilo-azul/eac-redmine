# frozen_string_literal: true

module Avm
  module Entries
    module Base
      class UriComponentsEntriesValues
        class GenericComponent
          common_constructor :owner, :component
          delegate :entries_provider_class, :prefix, to: :owner
          delegate :auto_method_name, :get_method_name, :get_optional_method_name,
                   to: :entry_key_path

          def define_auto_method
            outer_self = self
            entries_provider_class.define_method(auto_method_name) do
              uri_component_entry_value(outer_self.entry_key_path.to_string)
            end
          end

          def define_get_method
            outer_self = self
            entries_provider_class.define_method(get_method_name) do
              read_entry(outer_self.entry_key_path.to_string)
            end
          end

          def define_get_optional_method
            outer_self = self
            entries_provider_class.define_method(get_optional_method_name) do
              read_entry_optional(outer_self.entry_key_path.to_string)
            end
          end

          def define_inherited_value_proc_method(&block)
            entries_provider_class.define_method(inherited_value_proc_name, &block)
          end

          def entry_key_path
            ::EacConfig::EntryPath.assert([prefix, component])
          end

          def id_component
            @id_component ||= owner.component_factory('id')
          end

          def inherited_value_proc_name
            entry_key_path.inherited_block_method_name
          end

          def setup
            define_auto_method
            define_get_method
            define_get_optional_method
          end
        end
      end
    end
  end
end
