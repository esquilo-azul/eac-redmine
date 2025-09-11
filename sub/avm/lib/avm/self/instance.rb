# frozen_string_literal: true

module Avm
  module Self
    class Instance < ::Avm::Instances::Base
      DEFAULT_INSTANCE_ID = 'avm_self'

      class << self
        def default
          @default ||= by_id(DEFAULT_INSTANCE_ID)
        end
      end

      def docker_image_class
        ::Avm::Self::DockerImage
      end

      def docker_registry
        read_entry(::Avm::Self::Instance::EntryKeys::DOCKER_REGISTRY_NAME)
      end

      def docker_run_arguments
        ['-e', "LOCAL_USER_ID=#{::Process.uid}"]
      end
    end
  end
end
