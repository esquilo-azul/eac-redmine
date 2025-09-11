# frozen_string_literal: true

module Avm
  module Docker
    class Image < ::EacDocker::Images::Templatized
      prepend ::Avm::Entries::Jobs::WithVariablesSource

      DEFAULT_REGISTRY_NAME = 'local'

      class << self
        # @return [EacDocker::Registry]
        def default_registry
          ::EacDocker::Registry.new(DEFAULT_REGISTRY_NAME)
        end
      end

      attr_reader :registry
      attr_accessor :snapshot, :version

      def initialize(registry = nil)
        super()
        @registry = registry || self.class.default_registry
        self.snapshot = true
        self.version = true
      end

      def build(extra_args = [])
        nyi "Extra args: #{extra_args}" if extra_args.any?

        provide
      end

      def generator_version
        ::Avm::VERSION
      end

      def push
        ::EacDocker::Executables.docker.command.append(['push', tag]).system!
      end

      def run(instance)
        run_run(instance) if container_exist?(instance)
      end

      def tag
        r = tag_name
        r += ":#{tag_version}" if tag_version.present?
        r
      end

      def tag_name
        return registry.name if registry.name.present?

        raise 'Registry name is blank'
      end

      def tag_version
        [tag_version_version, stereotype_tag].compact_blank.join('_')
      end

      def tag_version_version
        return nil unless version

        r = generator_version
        r += '-snapshot' if snapshot
        r
      end
    end
  end
end
