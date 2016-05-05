module Avm
  module Listeners
    class IssueAutoUndefine
      module IssueRelationCreate
        def issue_relation_created_undefined
          return unless @event.entity == IssueRelation && @event.action == :create
          return unless relation.relation_type == IssueRelation::TYPE_BLOCKS
          return unless relation.issue_from.status == Avm::Settings.issue_status_undefined
          [relation.issue_to]
        end

        private

        def relation
          event.data
        end
      end
    end
  end
end
