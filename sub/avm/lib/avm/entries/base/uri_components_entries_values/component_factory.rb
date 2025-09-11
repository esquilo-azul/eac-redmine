# frozen_string_literal: true

module Avm
  module Entries
    module Base
      class UriComponentsEntriesValues
        class ComponentFactory
          enable_method_class
          common_constructor :owner, :component

          def result
            component_class.new(owner, component)
          end

          def component_class
            specific_class || generic_class
          end

          def generic_class
            parent_class.const_get('GenericComponent')
          end

          def parent_class
            ::Avm::Entries::Base::UriComponentsEntriesValues
          end

          def specific_class
            return nil unless parent_class.const_defined?(specific_class_basename)

            parent_class.const_get(specific_class_basename)
          end

          def specific_class_basename
            [component, 'component'].join('_').camelize
          end
        end
      end
    end
  end
end
