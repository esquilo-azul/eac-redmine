# frozen_string_literal: true

module Avm
  module Entries
    module Base
      class UriComponentsEntriesValues
        class UrlComponent < ::Avm::Entries::Base::UriComponentsEntriesValues::GenericComponent
          def define_auto_method
            outer_self = self
            entries_provider_class.define_method(auto_method_name) do
              inherited_entry_value(outer_self.id_component.entry_key_path.to_string,
                                    outer_self.entry_key_path.to_string) ||
                outer_self.auto_install_url_by_parts(self)
            end
          end

          def auto_install_url_by_parts(entries_provider)
            ::Avm::Entries::AutoValues::UriEntry.new(entries_provider, 'install').value
          end
        end
      end
    end
  end
end
