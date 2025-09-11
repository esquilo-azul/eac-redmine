# frozen_string_literal: true

module Avm
  module Registry
    class Instances < ::Avm::Registry::FromGems
      # @return [Avm::Instances::Base, nil]
      def class_detect(klass, detect_args)
        r = ::Avm::Instances::Base.by_id(*detect_args)
        r.application.stereotype.instance_class == klass ? klass.by_id(*detect_args) : nil
      end
    end
  end
end
