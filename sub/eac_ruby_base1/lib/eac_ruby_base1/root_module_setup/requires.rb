# frozen_string_literal: true

module EacRubyBase1
  class RootModuleSetup
    module Requires
      # @param require [String]
      # @return [void]
      def require(name)
        requires << name
      end

      # @return [void]
      def perform_requires
        requires.each { |name| ::Kernel.require(name) }
      end

      protected

      # @return [Array<String>]
      def requires
        @requires ||= []
      end
    end
  end
end
