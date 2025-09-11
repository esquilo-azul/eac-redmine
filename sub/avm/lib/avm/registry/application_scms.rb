# frozen_string_literal: true

module Avm
  module Registry
    class ApplicationScms < ::Avm::Registry::FromGems
      def class_detect(klass, detect_args)
        return nil unless klass.type_name == detect_args.fetch(0).scm_type

        klass.new(*detect_args)
      end
    end
  end
end
