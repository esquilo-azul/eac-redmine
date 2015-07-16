# encoding: UTF-8

module Trf1Sjap
  module Redmine
    class UnblockIssues      
      def self.check_all
        if !Setting.plugin_redmine_trf1_sjap['block_issue_status_id']
          Rails::logger.warn('Setting.plugin_redmine_trf1_sjap["block_issue_status_id"] não foi setado')
          return
        end
        blocked_issues.each do |issue|
          Rails::logger.debug "\##{issue.id} => blocked? #{blocked?(issue)})"
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
          return true if !child.status.is_closed            
        end
        false
      end

      def self.blocked_by_start_date?(issue)
        issue.start_date != nil && issue.start_date < Date.today
      end
    end
  end
end