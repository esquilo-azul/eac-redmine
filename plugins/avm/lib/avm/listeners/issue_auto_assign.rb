module Avm
  module Listeners
    class IssueAutoAssign
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def run
        return unless event.entity == ::Issue && event.action == :create
        Avm::Issue::Assign.new(event.data).run
      end
    end
  end
end
