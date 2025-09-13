# frozen_string_literal: true

module RedmineAvm
  module Issue
    class MotivationCheck
      def initialize(issue)
        @issue = issue
      end

      def run
        return if motivated?

        Rails.logger.info("##{@issue.id}: unmotivated")
        undefine
      end

      private

      def motivated?
        @issue.closed? || @issue.motivated?
      end

      def undefine
        @issue.init_journal(
          RedmineAvm::Settings.admin_user,
          RedmineAvm::Settings.unmotivated_message
        )
        @issue.status = RedmineAvm::Settings.issue_status_undefined
        @issue.save!
      end
    end
  end
end
