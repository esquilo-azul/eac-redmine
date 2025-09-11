# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs'

module Avm
  module Files
    module Appendable
      class TarOutputCommand < ::Avm::Files::Appendable::ResourceBase
        attr_reader :command

        def initialize(appender, command)
          super(appender)
          @command = command
        end

        def write_on(target_dir)
          command.pipe(
            ::EacRubyUtils::Envs.local.command('tar', '-xf', '-', '-C', target_dir)
          ).execute!
        end

        # @return [Enumerable<Symbol>]
        def to_s_attributes
          [:command]
        end
      end
    end
  end
end
