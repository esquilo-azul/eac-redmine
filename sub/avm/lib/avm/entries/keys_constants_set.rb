# frozen_string_literal: true

module Avm
  module Entries
    class KeysConstantsSet
      common_constructor :entries_provider_class, :prefix, :suffixes

      # @return [Array<String>]
      def result
        if suffixes.is_a?(::Hash)
          keys_consts_set_from_hash
        elsif suffixes.is_a?(::Enumerable)
          keys_consts_set_from_enum
        else
          raise "Unmapped suffixes class: #{suffixes.class}"
        end
      end

      private

      # @return [String]
      def key_const_set(prefix, suffix)
        key = [prefix, suffix].compact_blank.join('.')
        entries_provider_class.const_set(key.gsub('.', '_').upcase, key)
        key
      end

      # @return [Array<String>]
      def keys_consts_set_from_enum
        suffixes.map { |suffix| key_const_set(prefix, suffix) }
      end

      # @return [Array<String>]
      def keys_consts_set_from_hash
        suffixes.flat_map do |k, v|
          self.class.new(entries_provider_class, prefix.to_s + (k.blank? ? '' : ".#{k}"), v).result
        end
      end
    end
  end
end
