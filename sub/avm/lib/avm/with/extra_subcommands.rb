# frozen_string_literal: true

require 'eac_cli/runner_with/subcommands'

module Avm
  module With
    module ExtraSubcommands
      # @return [Hash<String, EacCli::Runner>]
      def extra_available_subcommands
        extra_available_subcommands_from_runners_module
      end

      # @return [Hash<String, EacCli::Runner>]
      def extra_available_subcommands_from_runners_module
        self.class.ancestors.reverse.inject({}) do |a, e|
          a.merge(RunnersFromModule.new(e).result)
        end
      end

      class RunnersFromModule
        enable_simple_cache
        common_constructor :the_module

        # @return [Hash<String, EacCli::Runner>]
        def result
          return {} if runners_module.blank?

          ::EacCli::RunnerWith::Subcommands.subcommands_from_module(runners_module)
        end

        def runners_module_uncached
          return nil if the_module.module_parent.blank?

          begin
            the_module.module_parent.const_get('Runners')
          rescue ::NameError
            nil
          end
        end
      end
    end
  end
end
