# frozen_string_literal: true

module RedmineAvm
  module Listeners
    class IssueAutoAssign
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def run
        issue = issue_to_check
        RedmineAvm::Issue::Assign.new(issue).run if issue
      end

      private

      def issue_to_check
        return event.data if event.issue_create?

        event.data.issue if event.issue_update?
      end
    end
  end
end
