# frozen_string_literal: true

module Avm
  module Data
    class Unit
      acts_as_abstract(
        do_clear: [],
        do_dump: [:dump_path],
        do_load: [:dump_path],
        dump_path_extension: []
      )
      enable_speaker
      include ::Avm::Data::Callbacks

      # @param dump_path [Pathname]
      # @return [void]
      def clear
        run_callbacks(:dump) { do_clear }
      end

      # @param dump_path [Pathname]
      # @return [void]
      def dump(dump_path)
        run_callbacks :dump do
          infom "Dumping unit \"#{name}\" to \"#{dump_path}\"..."
          do_dump(dump_path)
        end
      end

      # @param dump_path [Pathname]
      # @return [void]
      def load(dump_path)
        run_callbacks :load do
          clear
          infom "Loading unit \"#{name}\" from \"#{dump_path}\"..."
          do_load(dump_path)
        end
      end

      # @return [String]
      delegate :name, to: :class
    end
  end
end
