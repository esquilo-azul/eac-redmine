# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module Instances
    class Runner < ::Avm::Runners::Base
      runner_with :help, :subcommands do
        desc 'Utilities for a instance.'
        pos_arg 'instance-id'
        subcommands
      end

      delegate :class, to: :instance, prefix: true
      for_context :instance

      def extra_available_subcommands
        instance.if_present({}, &:extra_available_subcommands)
      end

      def stereotype_module
        instance.application.stereotype.namespace_module
      end

      def stereotype_name
        stereotype_module.name
      end

      private

      def instance_uncached
        parsed.instance_id.if_present { |v| ::Avm::Registry.instances.detect(v) }
      end
    end
  end
end
