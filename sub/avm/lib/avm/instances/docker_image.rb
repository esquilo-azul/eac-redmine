# frozen_string_literal: true

module Avm
  module Instances
    class DockerImage < ::Avm::Docker::Image
      attr_accessor :instance

      def stereotype_tag
        instance.id
      end
    end
  end
end
