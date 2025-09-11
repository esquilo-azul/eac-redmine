# frozen_string_literal: true

module Avm
  module Instances
    class Base
      module AutoValues
        module Data
          def auto_data_default_dump_path
            ::Avm::Self::Instance
              .default
              .read_entry_optional(::Avm::Self::Instance::EntryKeys::DATA_DEFAULT_PATH)
              .if_present do |v|
              ::File.join(
                v,
                "#{id}#{data_package.data_file_extension}"
              )
            end
          end

          # @return [Boolean]
          def auto_data_allow_loading # rubocop:disable Naming/PredicateMethod
            local? || !production?
          end
        end
      end
    end
  end
end
