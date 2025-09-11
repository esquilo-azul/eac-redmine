# frozen_string_literal: true

module Avm
  module Self
    class DockerImage < ::Avm::Docker::Image
      def stereotype_tag
        nil
      end
    end
  end
end
