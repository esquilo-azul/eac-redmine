# frozen_string_literal: true

module Avm
  module Instances
    class Base
      module AutoValues
        module Database
          LOCAL_ADDRESS = '127.0.0.1'
          LOCAL_ADDRESSES = [LOCAL_ADDRESS, '::1', 'localhost'].freeze
          DEFAULT_EXTRA = ''
          DEFAULT_HOSTNAME = LOCAL_ADDRESS
          DEFAULT_LIMIT = 5
          DEFAULT_PORTS = {
            'postgresql' => 5432,
            'mysql' => 3306,
            'oracle' => 1521,
            'sqlserver' => 1433
          }.freeze
          DEFAULT_SYSTEM = 'postgresql'
          DEFAULT_TIMEOUT = 5000

          %w[extra hostname limit system timeout].each do |attr|
            define_method "auto_database_#{attr}" do
              database_auto_common(attr) || self.class.const_get("default_#{attr}".upcase)
            end
          end

          %w[username password].each do |attr|
            define_method "auto_database_#{attr}" do
              database_auto_common(attr) || id
            end
          end

          def auto_database_name
            inherited_entry_value(::Avm::Instances::EntryKeys::DATABASE_ID,
                                  ::Avm::Instances::EntryKeys::DATABASE_NAME) || id
          end

          def auto_database_port
            database_auto_common('port') || database_port_by_system
          end

          private

          def database_auto_common(suffix)
            database_key = ::Avm::Instances::EntryKeys.const_get("database_#{suffix}".upcase)
            inherited_entry_value(::Avm::Instances::EntryKeys::DATABASE_ID, database_key) ||
              inherited_entry_value(::Avm::Instances::EntryKeys::INSTALL_ID, database_key)
          end

          def database_port_by_system
            read_entry_optional(::Avm::Instances::EntryKeys::DATABASE_SYSTEM).if_present do |v|
              DEFAULT_PORTS.fetch(v)
            end
          end
        end
      end
    end
  end
end
