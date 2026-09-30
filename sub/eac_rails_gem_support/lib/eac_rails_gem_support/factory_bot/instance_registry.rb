# frozen_string_literal: true

module EacRailsGemSupport
  module FactoryBot
    class InstanceRegistry
      class << self
        def default
          @default ||= ::EacRailsGemSupport::FactoryBot::InstanceRegistry.new
        end

        delegate :fetch, :reset, to: :default

        def sanitize_key(key)
          key.to_sym
        end
      end

      def fetch(key)
        key = self.class.sanitize_key(key)
        if fetched.key?(key)
          fetched.fetch(key)
        else
          fetched[key] = ::FactoryBot.create(key)
        end
      end

      def reset
        @fetched = nil
      end

      private

      def fetched
        @fetched ||= {}
      end
    end
  end
end
