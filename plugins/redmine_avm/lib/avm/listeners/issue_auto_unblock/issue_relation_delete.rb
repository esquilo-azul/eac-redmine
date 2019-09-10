# frozen_string_literal: true

module Avm
  module Listeners
    class IssueAutoUnblock
      module IssueRelationDelete
        def issue_relation_deleted
          return unless event.entity == IssueRelation && event.action == :delete
          return unless relation.relation_type == IssueRelation::TYPE_BLOCKS

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
