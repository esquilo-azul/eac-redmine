# frozen_string_literal: true

module Avm
  module With
    module ApplicationStereotype
      common_concern

      module ClassMethods
        # @return [Avm::ApplicationStereotype::Base]
        def application_stereotype
          @application_stereotype ||=
            ::Avm::Registry.application_stereotypes.detect(application_stereotype_name)
        end

        # @return [String]
        def application_stereotype_name
          stereotype_namespace_module.name.demodulize
        end

        # @return [Module]
        def stereotype_namespace_module
          module_parent.module_parent
        end
      end

      delegate :stereotype_namespace_module, to: :class
    end
  end
end
