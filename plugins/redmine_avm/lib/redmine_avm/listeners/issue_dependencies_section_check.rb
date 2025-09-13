# frozen_string_literal: true

module RedmineAvm
  module Listeners
    class IssueDependenciesSectionCheck
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def run
        issue = issue_to_check
        return unless issue
        return if issue.status == RedmineAvm::Settings.issue_status_undefined

        RedmineAvm::Issue::DependenciesSectionCheck.new(issue).run if issue
      end

      private

      def issue_to_check
        return event.data.issue if event.issue_update?

        event.data.issue_to if event.issue_relation_create? &&
                               event.data.relation_type == IssueRelation::TYPE_BLOCKS
      end
    end
  end
end
