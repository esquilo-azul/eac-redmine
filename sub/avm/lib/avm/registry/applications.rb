# frozen_string_literal: true

module Avm
  module Registry
    class Applications
      def initialize(*args); end

      # @return [Array<Avm::Applications::Base>]
      def available
        load_config
        detected.values
      end

      # @return [Avm::Applications::Base]
      def detect(id)
        id = id.to_s
        detected[id] = ::Avm::Applications::Base.new(id) unless detected.key?(id)
        detected[id]
      end

      private

      # @return [Hash<String, Avm::Applications::Base>]
      def detected
        @detected ||= {}
      end

      def load_config
        ::Avm::Registry.config_objects.available.each do |id, type|
          detect(id) if type == ::Avm::Applications::Base::AVM_TYPE
        end
      end
    end
  end
end
