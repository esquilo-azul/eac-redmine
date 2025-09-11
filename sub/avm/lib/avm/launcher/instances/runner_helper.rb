# frozen_string_literal: true

module Avm
  module Launcher
    module Instances
      module RunnerHelper
        common_concern do
          runner_definition do
            bool_opt '--all', 'Select all instances.'
            bool_opt '--pending', 'Select pending instances.'
            bool_opt '--recache', 'Rewrite instances cache.'
          end

          set_callback :run, :before, :setup_cache
        end

        def context
          @context ||= ::Avm::Launcher::Context.current
        end

        def instances
          collector = ::Avm::Launcher::Context::InstanceCollector.new(context)
          collector.add_all if parsed.all?
          collector.add_pending if parsed.pending?
          parsed.instance_path.flat_map { |p| collector.add_path(p) }
          collector.instances
        end

        def instance_stereotypes(instance)
          instance.stereotypes.map(&:label).join(', ')
        end

        def instance_label(instance)
          "#{instance.name} [#{instance_stereotypes(instance)}]"
        end

        def setup_cache
          ::Avm::Launcher::Context.current.recache = parsed.recache?
        end
      end
    end
  end
end
