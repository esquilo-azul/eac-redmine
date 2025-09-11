# frozen_string_literal: true

module Avm
  module Data
    class Package
      require_sub __FILE__, require_mode: :kernel
      include ::Avm::Data::Callbacks

      DATA_FILE_EXTENSION = '.tar'

      def initialize(options)
        options = options.to_options_consumer
        units = options.consume(:units)
        options.validate
        units.if_present do |v|
          v.each { |identifier, unit| add_unit(identifier, unit) }
        end
      end

      # @return [Avm::Data::Package] Return +self+.
      def add_unit(identifier, unit)
        units[identifier.to_sym] = unit

        self
      end

      # @return [String]
      def data_file_extension
        DATA_FILE_EXTENSION
      end

      def dump_units_to_directory(directory, selected_units = nil)
        run_callbacks :dump do
          (selected_units || units).each do |identifier, unit|
            unit.dump_to_directory(directory, identifier)
          end
        end
      end

      def load_units_from_directory(directory, selected_units = nil)
        run_callbacks :load do
          (selected_units || units).each do |identifier, unit|
            unit.load_from_directory(directory, identifier)
          end
        end
      end

      # @param id [Symbol]
      # @return [Avm::Data::UnitWithCommands]
      def unit(identifier)
        units[identifier.to_sym] || raise("No unit found with identifier \"#{identifier}\"")
      end

      def units
        @units ||= {}
      end

      # @return [Enumerable<String>]
      def units_ids
        units.keys
      end
    end
  end
end
