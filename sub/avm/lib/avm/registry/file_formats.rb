# frozen_string_literal: true

module Avm
  module Registry
    class FileFormats < ::Avm::Registry::FromGems
      # @return [Avm::FileFormats::Base]
      def class_detect(klass, detect_args)
        klass.new if klass.new.match?(detect_args.first)
      end

      # @return [Avm::FileFormats::Base, Avm::FileFormats::Unknown]
      def detect_optional(*registered_initialize_args)
        super || ::Avm::FileFormats::Unknown.new
      end
    end
  end
end
