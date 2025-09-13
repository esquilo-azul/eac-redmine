# frozen_string_literal: true

module Avm
  module Issue
    class Unblock
      def initialize(issue)
        @issue = issue
      end

      def run
        msg = unblock?
        if msg
          Rails.logger.debug(msg)
        else
          Rails.logger.debug { "##{@issue.id} has no open dependencies. Unblocking..." }
          unblock
        end
      end

      private

      def unblock? # rubocop:disable Naming/PredicateMethod
        return "##{@issue.id} is not blocked" unless status_blocked?
        return "##{@issue.id} has open dependencies" if open_dependencies?
      end

      def status_blocked?
        @issue.status == Avm::Settings.issue_status_blocked
      end

      def open_dependencies?
        @issue.dependencies.any? { |d| !d.closed? }
      end

      def unblock
        @issue.init_journal(
          Avm::Settings.admin_user,
          I18n.translate(:issue_unblock_message)
        )
        @issue.status = Avm::Settings.issue_status_unblocked
        @issue.save!
      end
    end
  end
end
