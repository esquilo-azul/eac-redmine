# encoding: UTF-8

module Trf1Sjap
  module Redmine
    class UnblockIssues
      def self.check_all
        unless Setting.plugin_redmine_trf1_sjap['block_issue_status_id']
          Rails.logger.warn('Setting.plugin_redmine_trf1_sjap["block_issue_status_id"] não foi setado. Nenhum issue bloqueado será verificado.')
          return
        end
        can_unblock = true
        unless Setting.plugin_redmine_trf1_sjap['unblock_issue_status_id']
          Rails.logger.warn('Setting.plugin_redmine_trf1_sjap["unblock_issue_status_id"] não foi setado. Nenhum issue será desbloqueado.')
          can_unblock = false
        end
        unless Setting.plugin_redmine_trf1_sjap['admin_user_id']
          Rails.logger.warn('Setting.plugin_redmine_trf1_sjap["admin_user_id"] não foi setado. Nenhum issue será desbloqueado.')
          can_unblock = false
        end
        unless Setting.plugin_redmine_trf1_sjap['unblock_message']
          Rails.logger.warn('Setting.plugin_redmine_trf1_sjap["unblock_message"] não foi setado. Nenhum issue será desbloqueado.')
          can_unblock = false
        end
        blocked_issues.each do |issue|
          blocked = blocked?(issue)
          Rails.logger.debug "\##{issue.id} => blocked? #{blocked})"
          if !blocked['result'] && can_unblock
            unblock(issue)
            Rails.logger.info "\##{issue.id} desbloqueado"
          end
        end
      end

      def self.blocked_issues
        Issue.where(status_id: Setting.plugin_redmine_trf1_sjap['block_issue_status_id'])
      end

      def self.blocked?(issue)
        result = {
          'relations' => blocked_by_relations?(issue),
          'children' => blocked_by_children?(issue),
          'start_date' => blocked_by_start_date?(issue)
        }
        result['result'] = result['relations'] || result['children'] || result['start_date']
        result
      end

      def self.blocked_by_relations?(issue)
        issue.relations_to.each do |rel|
          return true if rel.relation_type == IssueRelation::TYPE_BLOCKS && !rel.issue_from.status.is_closed
        end
        false
      end

      def self.blocked_by_children?(issue)
        issue.children.each do |child|
          return true unless child.status.is_closed
        end
        false
      end

      def self.blocked_by_start_date?(issue)
        !issue.start_date.nil? && issue.start_date > Date.today
      end

      def self.unblock(issue)
        issue.init_journal(User.find(Setting.plugin_redmine_trf1_sjap['admin_user_id']), Setting.plugin_redmine_trf1_sjap['unblock_message'])
        issue.status = IssueStatus.find(Setting.plugin_redmine_trf1_sjap['unblock_issue_status_id'])
        Trf1Sjap::ModelUtils.save_or_raise(issue)
      end
    end
  end
end
