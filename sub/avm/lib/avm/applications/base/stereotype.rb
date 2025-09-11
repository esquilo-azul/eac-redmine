# frozen_string_literal: true

module Avm
  module Applications
    class Base
      module Stereotype
        # @return [Avm::ApplicationStereotypes::Base, nil]
        def stereotype_by_configuration
          entry('stereotype').optional_value.if_present do |v|
            ::Avm::Registry.application_stereotypes.detect(v)
          end
        end

        # @return [Avm::ApplicationStereotypes::Base, nil]
        def stereotype_by_source
          ::Avm::Registry.application_stereotypes.detect_optional(local_source.class)
        end

        private

        # @return [Avm::ApplicationStereotypes::Base]
        def stereotype_uncached
          stereotype_by_configuration || stereotype_by_source ||
            raise("Could not find stereotype for application \"#{self}\"")
        end
      end
    end
  end
end
