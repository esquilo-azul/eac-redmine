# frozen_string_literal: true

module Avm
  module Issue
    class Undefine
      def initialize(issue)
        @issue = issue
      end

      def run
        msg = undefine?
        if msg
          Rails.logger.debug(msg)
        else
          Rails.logger.debug { "##{@issue.id} has undefined dependencies. Undefining..." }
          undefine
        end
      end

      private

      def undefine? # rubocop:disable Naming/PredicateMethod
        return "##{@issue.id} already undefined" if @issue.undefined?
        return "##{@issue.id} already closed" if @issue.closed?

        "##{@issue.id} has no undefined dependencies" unless @issue.dependencies.any?(
          &:undefined?
        )
      end

      def undefine
        @issue.init_journal(
          Avm::Settings.admin_user,
          I18n.t(
            :issue_undefine_message,
            undefined_dependencies_ids: undefined_dependency_ids_string
          )
        )
        @issue.status = Avm::Settings.issue_status_undefined
        @issue.save!
      end

      def undefined_dependency_ids_string
        @issue.dependencies.select(&:undefined?).map { |i| "##{i.id}" }.join(', ')
      end
    end
  end
end
