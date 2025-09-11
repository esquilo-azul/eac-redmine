# frozen_string_literal: true

module Avm
  module Registry
    class ApplicationStereotypes
      class BuildAvailable
        enable_method_class

        common_constructor :owner

        def result
          reset_buffer
          read_registries
          buffer.values.map(&:build)
        end

        private

        attr_accessor :buffer

        def read_object(type, object)
          buffer[object.stereotype_namespace_module] ||=
            ::Avm::Registry::ApplicationStereotypes::StereotypeBuilder
              .new(object.stereotype_namespace_module)
          buffer[object.stereotype_namespace_module].add_object(type, object)
        end

        def read_registries
          ::Avm::ApplicationStereotypes::Base.lists.resource.each_value do |resource|
            read_registry(resource)
          end
        end

        def read_registry(resource)
          ::Avm::Registry.send(resource.to_s.pluralize).available
            .each { |obj| read_object(resource, obj) }
        end

        def reset_buffer
          self.buffer = {}
        end
      end
    end
  end
end
