# frozen_string_literal: true

module Avm
  module Applications
    class Base
      module Organization
        DEFAULT_ORGANIZATION = '_undefined_'
        ORGANIZATION_CONFIG_KEY = 'organization'

        # @return [String]
        def default_organization
          DEFAULT_ORGANIZATION
        end

        # @return [String, nil]
        def organization_by_configuration
          entry(ORGANIZATION_CONFIG_KEY).optional_value
        end

        # @return [String]
        def organization
          organization_by_configuration || default_organization
        end
      end
    end
  end
end
