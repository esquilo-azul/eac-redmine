# frozen_string_literal: true

module Avm
  module Listeners
    class IssueAutoUndefine
      module IssueCreate
        def issue_created_undefined
          return unless event.entity == Issue && event.action == :create
          return unless issue.status == Avm::Settings.issue_status_undefined
          return unless issue.parent

          [issue.parent]
        end

        private

        def issue
          event.data
        end
      end
    end
  end
end
