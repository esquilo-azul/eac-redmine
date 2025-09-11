# frozen_string_literal: true

require 'eac_cli/runner/context'

module Avm
  module Instances
    class Base
      class SubcommandParent
        include ::EacCli::Runner

        enable_simple_cache
        common_constructor :instance do
          self.runner_context = ::EacCli::Runner::Context.new(self, argv: runner_argv)
        end
        for_context :instance

        private

        def runner_argv
          [instance.class.name.split('::')[-2].dasherize, instance.id]
        end
      end
    end
  end
end
