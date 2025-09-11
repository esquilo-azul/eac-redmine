# frozen_string_literal: true

require 'eac_config/node'

module Avm
  module Entries
    module AutoValues
      class Entry
        class << self
          # @param path [EacConfig::EntryPath]
          # @return String
          def auto_value_method_name(path)
            "auto_#{::EacConfig::EntryPath.assert(path).to_string.gsub('.', '_')}"
          end
        end

        # @!method initialize(entries_provider, path)
        #   @param entries_provider
        #   @param path [EacConfig::EntryPath]
        common_constructor :entries_provider, :path do
          self.path = ::EacConfig::EntryPath.assert(path)
        end

        def auto_value_method
          self.class.auto_value_method_name(path)
        end

        def found?
          entries_provider.respond_to?(auto_value_method, true)
        end

        def value
          entries_provider.if_respond(auto_value_method)
        end
      end
    end
  end
end
