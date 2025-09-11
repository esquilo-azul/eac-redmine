# frozen_string_literal: true

module Avm
  module Entries
    class UriBuilder
      FIELDS = %w[scheme user password host port path query fragment].freeze
      FIELDS_TRANSLATIONS = {
        username: :user, hostname: :host
      }.freeze
      ENTRIES_FIELDS = FIELDS.map do |field|
        FIELDS_TRANSLATIONS.key(field.to_sym).if_present(field).to_s
      end

      class << self
        def from_all_fields(&block)
          r = new
          ENTRIES_FIELDS.each do |field_name|
            field_value = block.call(field_name)
            r.field_set(field_name, field_value) if field_value.present?
          end
          r
        end

        def from_source(source)
          if source.is_a?(::Addressable::URI)
            from_source_uri(source)
          elsif source.blank?
            new
          else
            raise "Unexpected source: #{source}"
          end
        end

        def from_source_uri(source_uri)
          new(source_uri.to_hash)
        end
      end

      common_constructor :data, default: [{}]

      def avm_field_get(avm_field)
        field_get(translate_field(avm_field))
      end

      # @return [String, nil]
      def field_get(name)
        v = data[name.to_sym]
        v&.to_s
      end

      def field_set(field, value)
        tfield = translate_field(field)
        if FIELDS.include?(tfield)
          main_field_set(tfield, value)
        else
          sub_field_set(tfield, value)
        end
      end

      def translate_field(field)
        if FIELDS_TRANSLATIONS.key?(field.to_sym)
          FIELDS_TRANSLATIONS.fetch(field.to_sym).to_s
        else
          field.to_s
        end
      end

      # @return [Addressable::URI, nil]
      def to_uri
        to_required_uri
      rescue ::Addressable::URI::InvalidURIError
        nil
      end

      # @return [Addressable::URI]
      def to_required_uri
        ::Addressable::URI.new(FIELDS.to_h { |f| [f.to_sym, field_get(f)] })
      end

      private

      def main_field_set(name, value)
        data[name.to_sym] = value
      end
    end
  end
end
