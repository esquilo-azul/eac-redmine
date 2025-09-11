# frozen_string_literal: true

module Avm
  module Instances
    class Base
      module AutoValues
        module Mailer
          ::Avm::Instances::EntryKeys.all.select { |c| c.to_s.start_with?('mailer.') }
            .reject { |c| c == ::Avm::Instances::EntryKeys::MAILER_ID }
            .each do |mailer_key|
            define_method ::Avm::Entries::AutoValues::Entry.auto_value_method_name(mailer_key) do
              mailer_auto_common(mailer_key)
            end
          end

          def auto_mailer_id
            inherited_entry_value(::Avm::Instances::EntryKeys::INSTALL_ID,
                                  ::Avm::Instances::EntryKeys::MAILER_ID) ||
              read_entry_optional(::Avm::Instances::EntryKeys::INSTALL_ID)
          end

          private

          def mailer_auto_common(mailer_key)
            inherited_entry_value(::Avm::Instances::EntryKeys::MAILER_ID, mailer_key)
          end
        end
      end
    end
  end
end
