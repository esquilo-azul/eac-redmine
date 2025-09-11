# frozen_string_literal: true

module Avm
  module Applications
    class Base
      enable_simple_cache
      include ::Avm::Entries::Base

      AVM_TYPE = 'Application'

      class << self
        # @param id [String]
        # @return [Avm::Applications::Base]
        def by_id(id)
          new(id)
        end
      end

      common_constructor :id do
        self.id = id.to_s
      end

      def to_s
        id
      end

      def instance(suffix)
        stereotype.instance_class.new(self, suffix)
      end

      require_sub __FILE__, include_modules: true, require_mode: :kernel
    end
  end
end
