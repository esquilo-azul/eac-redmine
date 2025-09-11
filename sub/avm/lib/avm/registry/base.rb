# frozen_string_literal: true

module Avm
  module Registry
    class Base
      acts_as_abstract
      common_constructor :module_suffix

      def available
        raise_abstract __method__
      end

      def to_s
        "#{self.class}[#{module_suffix}]"
      end

      private

      def raise_not_found(*args)
        raise(::Avm::Registry::DetectionError,
              "No registered module valid for #{args} " \
              "(Module suffix: #{module_suffix}, Available: #{available.join(', ')})")
      end
    end
  end
end
