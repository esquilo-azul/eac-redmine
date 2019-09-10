# frozen_string_literal: true

module Avm
  module Listeners
    class IssueAutoUnblock
      module IssueDelete
        def issue_deleted
          return unless event.entity == ::Issue && event.action == :delete

          ::Issue.where(status: Avm::Settings.issue_status_blocked)
        end

        private

        def issue
          event.data
        end
      end
    end
  end
end
