# frozen_string_literal: true

require 'eac_docker/executables'

module Avm
  module Instances
    class Base
      module Dockerizable
        enable_simple_cache
        attr_reader :docker_image_options

        def docker_image_options=(options)
          @docker_image_options = ::ActiveSupport::HashWithIndifferentAccess.new(options)
          reset_cache
        end

        def docker_container_exist?
          ::EacDocker::Executables.docker.command.append(
            ['ps', '-qaf', "name=#{docker_container_name}"]
          ).execute!.present?
        end

        def docker_container_name
          id
        end

        private

        def docker_container_uncached
          ::Avm::Docker::Container.new(self)
        end

        def docker_image_uncached
          r = docker_image_class.new(docker_image_options.fetch(:registry))
          r.instance = self if r.respond_to?(:instance)
          r.version = docker_image_options[:version] if docker_image_options.key?(:version)
          r.snapshot = docker_image_options[:snapshot] if docker_image_options.key?(:snapshot)
          r
        end
      end
    end
  end
end
