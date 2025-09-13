# frozen_string_literal: true

module Avm
  module Issue
    class DependenciesSectionCheck
      def initialize(issue)
        @issue = issue
      end

      def run
        return if @issue.closed?
        return if @issue.dependencies.empty?

        unless @issue.dependencies_section
          Rails.logger.info("##{@issue.id}: no section found")
          undefine_no_dependencies_secion
          return
        end
        return if all_dependencies_in_dependencies_section?

        Rails.logger.info("##{@issue.id}: missing dependencies in dependency section")
        undefine_no_all_dependencies
      end

      private

      def all_dependencies_in_dependencies_section?
        sec_deps = @issue.dependencies_section_dependencies
        @issue.dependencies.all? { |d| sec_deps.include?(d.id) }
      end

      def undefine_no_dependencies_secion
        @issue.init_journal(
          Avm::Settings.admin_user,
          Avm::Settings.no_dependencies_section_message
        )
        @issue.status = Avm::Settings.issue_status_undefined
        @issue.save!
      end

      def undefine_no_all_dependencies
        @issue.init_journal(
          Avm::Settings.admin_user,
          format(Avm::Settings.dependencies_section_missing_dependencies_message,
                 ids: no_dependencies_section_ids_string)
        )
        @issue.status = Avm::Settings.issue_status_undefined
        @issue.save!
      end

      def no_dependencies_section_ids_string
        sec_deps = @issue.dependencies_section_dependencies
        deps = @issue.dependencies.map(&:id)
        (deps - sec_deps).map { |id| "##{id}" }.join(', ')
      end
    end
  end
end
