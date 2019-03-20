module Avm
  module Listeners
    class IssueAutoUndefine
      module IssueUpdate
        def issue_updated_undefined
          return unless issue_update_event?
          return journal.issue.r_dependencies if status_changed_to_undefined?
          return [journal.issue] if status_changed_from_undefined?
          return [journal.issue.parent] if parent_changed_and_undefined?
        end

        private

        def issue_update_event?
          @event.entity == Issue && @event.action == :update
        end

        def journal
          @event.data
        end

        def status_changed_to_undefined?
          new_integer_value('status_id') == Avm::Settings.issue_status_undefined.id
        end

        def status_changed_from_undefined?
          old_integer_value('status_id') == Avm::Settings.issue_status_undefined.id
        end

        def parent_changed_and_undefined?
          new_integer_value('parent_id') && journal.issue.undefined?
        end

        def new_integer_value(attr)
          d = journal.detail_for_attribute(attr)
          return nil unless d
          d.value.to_i
        end

        def old_integer_value(attr)
          d = journal.detail_for_attribute(attr)
          return nil unless d
          d.old_value.to_i
        end
      end
    end
  end
end
