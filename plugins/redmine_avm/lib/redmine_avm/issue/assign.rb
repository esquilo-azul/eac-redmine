# frozen_string_literal: true

module RedmineAvm
  module Issue
    class Assign
      attr_reader :issue

      def initialize(issue)
        @issue = issue
      end

      def run
        return unless issue_status_assign && issue_has_assign_field?
        return unless issue.assigned_to || issue_status_user
        return if issue.assigned_to == issue_status_user

        assign
      end

      private

      def issue_status_assign
        @issue_status_assign ||= IssueStatusAssign.where(issue_status: issue.status).first
      end

      def issue_has_assign_field?
        issue.available_custom_fields.include?(issue_status_assign.issue_field)
      end

      def issue_status_user
        id = issue.custom_field_value(issue_status_assign.issue_field)
        id.present? ? User.find(id) : nil
      end

      def assign
        user = issue_status_user
        Rails.logger.debug { "Assigning #{user} to #{issue}" }
        user_label = user ? user.to_s : 'NENHUM'
        @issue.init_journal(
          RedmineAvm::Settings.admin_user,
          I18n.t(:issue_assign_message, user: user_label, issue_status: issue.status,
                                        issue_field: issue_status_assign.issue_field.name)
        )
        @issue.assigned_to = user
        @issue.save!
      end
    end
  end
end
