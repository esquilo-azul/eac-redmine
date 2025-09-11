# frozen_string_literal: true

module Avm
  module EacRubyBase1
    class Rubocop
      require_sub __FILE__, include_modules: true
      enable_speaker
      enable_simple_cache
      common_constructor :base_path, :rubocop_args
      set_callback :initialize, :after do
        @base_path = ::Pathname.new(base_path.to_s) unless base_path.is_a?(::Pathname)
      end

      def run
        start_banner
        run_rubocop
      end

      private

      def cmd(*args)
        ::EacRubyUtils::Envs.local.command(*args)
      end

      def rubocop_command_uncached
        %w[env configured gemfile].each do |s|
          cmd = send("#{s}_rubocop_command")
          return cmd if cmd.present?
        end
        cmd('rubocop')
      end

      def rubocop_command_with_args
        rubocop_command.append(rubocop_args)
      end

      def rubocop_version_uncached
        ::EacRubyUtils::Ruby.on_clean_environment do
          rubocop_command.append(['--version']).execute!.strip
        end
      end

      def run_rubocop
        ::EacRubyUtils::Ruby.on_clean_environment { rubocop_command_with_args.system }
      end

      def start_banner
        infov 'Rubocop version', rubocop_version
      end
    end
  end
end
