# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  module Tasks
    class System
      common_constructor :command_string

      def banner
        ::Rails.logger.info("Command string: #{command_string}")
        ::Rails.logger.info("Command arguments: #{command_args}")
      end

      # @return [EacRubyUtils::Envs::Command]
      def command
        host_env.command(*command_args)
      end

      # @return [Array<String>]
      def command_args
        ::Shellwords.split(command_string)
      end

      # @return [EacRubyUtils::Envs::Local]
      def host_env
        ::EacRubyUtils::Envs.local
      end

      def perform
        banner
        command.system!
      end
    end
  end
end
