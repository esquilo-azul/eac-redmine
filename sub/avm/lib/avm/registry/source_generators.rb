# frozen_string_literal: true

module Avm
  module Registry
    class SourceGenerators < ::Avm::Registry::FromGems
      # @return [Avm::Instances::Base, nil]
      def class_detect(klass, detect_args)
        detect_args = detect_args.dup
        stereotype_name = detect_args.shift
        klass.application_stereotype.name == stereotype_name ? klass.new(*detect_args) : nil
      end
    end
  end
end
