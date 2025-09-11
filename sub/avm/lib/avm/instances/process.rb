# frozen_string_literal: true

module Avm
  module Instances
    class Process
      class << self
        # @return [Symbol]
        def default_id
          name.demodulize.underscore.to_sym
        end
      end

      acts_as_abstract :available?, :disable, :enable, :enabled?
      common_constructor :instance, :id, default: [nil] do
        self.id ||= (id || self.class.default_id).to_sym
      end

      def on_disabled(&block)
        previous_enabled = enabled?
        begin
          disable if previous_enabled
          block.call
        ensure
          enable if previous_enabled
        end
      end
    end
  end
end
