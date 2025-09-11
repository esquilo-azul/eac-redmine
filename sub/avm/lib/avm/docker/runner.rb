# frozen_string_literal: true

module Avm
  module Docker
    class Runner
      DOCKER_DEFAULT_REGISTRY_METHOD = :docker_default_registry
      DOCKER_DEFAULT_REGISTRY_NAME = 'local'

      enable_speaker
      enable_simple_cache

      runner_with :help do
        desc 'Manipulate Docker images.'
        bool_opt '-I', '--image-name', 'Output image name.'
        arg_opt '-n', '--registry-name', 'Docker registry\'s name.'
        bool_opt '-p', '--push', 'Push the image to Docker registry.'
        bool_opt '-r', '--run', 'Run or start a container with builded image.'
        arg_opt '-B', '--build-arg', 'Argument for "docker build".', repeat: true
        arg_opt '-E', '--entrypoint-arg', 'Argument for entrypoint on "docker run"', repeat: true
        bool_opt '-c', '--clear', 'Remove container if exist before run.'
        bool_opt '-S', '--no-snapshot', 'Does not add "-snapshot" to image tag.'
        bool_opt '-V', '--no-version', 'Does not add version to image tag.'
      end

      def run
        setup
        banner
        build
        output_image_name
        push
        container_run
      end

      # @return [EacDocker::Registry, nil]
      def docker_default_registry
        ::EacDocker::Registry.new(default_docker_registry_name)
      end

      private

      def setup
        instance.docker_image_options = {
          registry: registry,
          snapshot: snapshot?,
          version: version?
        }
      end

      def banner
        infov 'Registry name', registry
        infov 'Version?', version?
        infov 'Snapshot?', snapshot?
        infov 'Image name', docker_image.tag
        infov 'Build arguments', build_args
        infov 'Entrypoint arguments', entrypoint_args
      end

      def build
        docker_image.build(build_args)
        success 'Docker image builded'
      end

      def build_args
        parsed.build_arg
      end

      def docker_container
        instance.docker_container
      end

      # @return [String]
      def default_docker_registry_name
        DOCKER_DEFAULT_REGISTRY_NAME
      end

      def docker_image
        instance.docker_image
      end

      def entrypoint_args
        parsed.entrypoint_arg
      end

      def push
        docker_image.push if parsed.push?
      end

      def container_run
        return unless parsed.run?

        docker_container.run(
          entrypoint_args: entrypoint_args,
          clear: parsed.clear?
        )
      end

      def output_image_name
        return unless parsed.image_name

        out("#{docker_image.tag.to_s.strip}\n")
      end

      def registry_uncached
        registry_from_option || registry_from_instance || registry_from_default ||
          fatal_error('No registry defined')
      end

      def registry_from_option
        parsed.registry_name.if_present { |v| ::EacDocker::Registry.new(v) }
      end

      def registry_from_instance
        instance.docker_registry_optional.if_present { |v| ::EacDocker::Registry.new(v) }
      end

      def registry_from_default
        if_respond(DOCKER_DEFAULT_REGISTRY_METHOD, nil)
      end

      def snapshot?
        !parsed.no_snapshot?
      end

      def version?
        !parsed.no_version?
      end
    end
  end
end
