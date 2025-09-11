# frozen_string_literal: true

module Avm
  module Sources
    class Base
      class SubsPaths
        SUBS_PATH_SEPARATOR = ':'

        common_constructor :source, :configuration_key, :default_paths

        # @return [String]
        def path
          paths.join(SUBS_PATH_SEPARATOR)
        end

        # @return [Array<String>]
        def paths
          configured_paths || default_paths
        end

        # @return [Array<String>]
        def configured_paths
          source.configuration_entry(configuration_key).value.if_present do |v|
            v.split(SUBS_PATH_SEPARATOR)
          end
        end
      end
    end
  end
end
