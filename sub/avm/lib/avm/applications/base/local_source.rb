# frozen_string_literal: true

require 'eac_config/node'

module Avm
  module Applications
    class Base
      module LocalSource
        # @return [Pathname]
        def local_source_path
          user_local_source_path || auto_local_source_path
        end

        # @return [EacConfig::Entry]
        def local_source_path_entry
          ::EacConfig::Node.context.current.entry([local_instance_id, 'install', 'path'])
        end

        # @return [Path, nil]
        def user_local_source_path
          local_source_path_entry.value.if_present(&:to_pathname)
        end

        private

        # @return [Avm::Sources::Base]
        def local_source_uncached
          ::Avm::Registry.sources.detect(local_source_path)
        end
      end
    end
  end
end
