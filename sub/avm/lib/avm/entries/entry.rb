# frozen_string_literal: true

require 'eac_config/node'

module Avm
  module Entries
    class Entry
      common_constructor :parent, :suffix, :options

      def auto_value
        auto_value_entry.value
      end

      def auto_value_entry
        @auto_value_entry ||= ::Avm::Entries::AutoValues::Entry.new(parent, suffix)
      end

      # @return [Boolean]
      def context_found?
        context_entry.found?
      end

      # @return [Boolean]
      def found?
        context_found?
      end

      def full_path
        (parent.path_prefix + suffix_as_array).join('.')
      end

      def optional_value
        context_entry.found? ? context_entry.value : auto_value
      end

      def read
        context_entry.value
      end

      def suffix_as_array
        if suffix.is_a?(::Array)
          suffix.dup
        else
          ::EacConfig::PathsHash.parse_entry_key(suffix.to_s)
        end
      end

      def value
        optional_value || read
      end

      def value!
        optional_value.if_present { |v| return v }
        context_entry.value!
      end

      def write(value)
        context_entry.value = value
      end

      private

      def context_entry
        current_node = ::EacConfig::Node.context.optional_current
        return current_node.entry(full_path) if current_node.present?

        ::Avm::Entries::Entry::NoContextEntry.new
      end
    end
  end
end
