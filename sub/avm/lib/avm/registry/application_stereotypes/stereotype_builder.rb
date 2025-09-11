# frozen_string_literal: true

module Avm
  module Registry
    class ApplicationStereotypes
      class StereotypeBuilder
        common_constructor :namespace_module

        def add_object(type, object)
          type = type.to_sym
          raise "#{attr_method} is already present" if resources.key?(type)

          resources[::Avm::ApplicationStereotypes::Base.lists.resource.value_validate!(type)] =
            object
        end

        # @return [Avm::ApplicationStereotypes::Base]
        def build
          ::Avm::ApplicationStereotypes::Base.new(namespace_module, resources)
        end

        private

        def resources
          @resources ||= {}
        end
      end
    end
  end
end
