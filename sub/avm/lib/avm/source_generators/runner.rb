# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module SourceGenerators
    class Runner
      OPTION_NAME_VALUE_SEPARATOR = ':'

      runner_with :help do
        arg_opt '-o', '--option', 'Option for generator.', repeat: true, optional: true
        pos_arg :stereotype_name
        pos_arg :target_path
      end

      def run
        start_banner
        generate
      end

      def generate
        infom 'Generating...'
        generator.perform
        success "Source generated in \"#{generator.target_path}\""
      end

      # @return [String]
      def help_extra_text
        help_list_section('Stereotypes', ::Avm::Registry.source_generators.available
          .map(&:application_stereotype_name))
      end

      def start_banner
        infov 'Stereotype', stereotype_name
        infov 'Target path', target_path
        infov 'Generator', generator.class
      end

      def generator_uncached
        ::Avm::Registry.source_generators
          .detect_optional(stereotype_name, target_path, options) ||
          fatal_error("No generator found for stereotype \"#{stereotype_name}\"")
      end

      delegate :stereotype_name, to: :parsed

      # @return [Hash<String, String>]
      def options
        parsed.option.to_h { |v| v.split(OPTION_NAME_VALUE_SEPARATOR) }
      end

      def target_path
        parsed.target_path.to_pathname
      end
    end
  end
end
