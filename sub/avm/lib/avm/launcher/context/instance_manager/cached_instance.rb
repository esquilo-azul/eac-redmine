# frozen_string_literal: true

module Avm
  module Launcher
    class Context
      class InstanceManager
        class CachedInstance
          enable_speaker
          enable_simple_cache
          common_constructor :cached_instances, :data

          private

          def instance_uncached
            ::Avm::Launcher::Instances::Base.instanciate(path, parent_instance)
          rescue ::Avm::Launcher::Errors::NonProject
            warn "Cached instance \"#{data[:logical]}\" not found"
            nil
          end

          def parent_instance_uncached
            data[:parent]
              .if_present { |v| cached_instances.by_logical_path(v) }
              .if_present(&:instance)
          end

          def path_uncached
            ::Avm::Launcher::Paths::Logical.from_h(cached_instances.context, data)
          end
        end
      end
    end
  end
end
