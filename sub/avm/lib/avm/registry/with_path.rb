# frozen_string_literal: true

module Avm
  module Registry
    class WithPath < ::Avm::Registry::FromGems
      require_sub __FILE__

      # @return [Object, nil]
      def class_detect(klass, detect_args)
        r = klass.new(*detect_args)
        r.valid? ? r : nil
      end

      def detect_by_path(path)
        detect_by_path_optional(path) || raise_not_found(path)
      end

      def detect_by_path_optional(path)
        on_cache do
          cache.detect_optional(path)
        end
      end

      private

      attr_accessor :cache

      def on_cache(&block)
        cache.present? ? on_cache_with_cache(&block) : on_cache_with_no_cache(&block)
      end

      def on_cache_with_cache(&block)
        block.call
      end

      def on_cache_with_no_cache(&block)
        self.cache = ::Avm::Registry::WithPath::Cache.new(self)
        begin
          block.call
        ensure
          self.cache = nil
        end
      end
    end
  end
end
