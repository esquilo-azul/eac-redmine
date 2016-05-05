module Avm
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def undefined?
          status == Avm::Settings.issue_status_undefined
        end

        def dependencies
          children.all + relations_to.select do |r|
            r.relation_type == IssueRelation::TYPE_BLOCKS
          end.map(&:issue_from)
        end

        def r_dependencies
          rd = []
          rd << parent if parent
          rd + relations_from.select do |r|
            r.relation_type == IssueRelation::TYPE_BLOCKS
          end.map(&:issue_to)
        end
      end
    end
  end
end

unless Issue.included_modules.include? Avm::Patches::IssuePatch
  Issue.send(:include, Avm::Patches::IssuePatch)
end
