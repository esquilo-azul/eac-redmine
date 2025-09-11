# frozen_string_literal: true

module Avm
  module Data
    class UnitWithCommands < ::Avm::Data::Unit
      acts_as_abstract

      abstract_method :dump_command
      abstract_method :load_command

      # @return [String]
      def dump_path_extension
        singleton_class.const_get('EXTENSION')
      rescue NameError
        ''
      end

      def load_from_directory(directory, identifier)
        load(unit_on_directory_path(directory, identifier))
      end

      def dump_to_directory(directory, identifier)
        dump(unit_on_directory_path(directory, identifier))
      end

      # @return [Struct(:key, :subpath), nil]
      def installation_files_data
        nil
      end

      protected

      def do_dump(data_path)
        dump_command.execute!(output_file: data_path)
      end

      def do_load(data_path)
        load_command.execute!(input_file: data_path)
      end

      private

      def unit_on_directory_path(directory, identifier)
        ::File.join(directory, "#{identifier}#{dump_path_extension}")
      end
    end
  end
end
