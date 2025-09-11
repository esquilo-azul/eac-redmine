# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module Sources
    class Runner
      runner_with :help, :subcommands do
        desc 'Root command for sources.'
        arg_opt '-C', '--path', 'Path to the source.', default: '.'
        subcommands
      end

      for_context :optional_source, :source

      def extra_available_subcommands
        optional_source.if_present({}, &:extra_available_subcommands)
      end

      def source_banner
        infov 'Source', source
      end

      # @return [Pathname]
      def source_path
        parsed.path.to_pathname
      end

      private

      def source_uncached
        ::Avm::Registry.sources.detect(source_path)
      end

      def optional_source_uncached
        ::Avm::Registry.sources.detect_optional(source_path)
      end
    end
  end
end
