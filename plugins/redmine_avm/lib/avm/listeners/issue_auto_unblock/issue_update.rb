module Avm
  module Listeners
    class IssueAutoUnblock
      module IssueUpdate
        def issue_updated
          return unless issue_update_event?
          return [issue] if status_changed_to_blocked?
          return issue.r_dependencies if status_changed_to_closed?
        end

        private

        def issue_update_event?
          event.entity == ::Issue && event.action == :update
        end

        def journal
          event.data
        end

        def issue
          journal.issue
        end

        def status_changed_to_blocked?
          new_integer_value('status_id') == Avm::Settings.issue_status_blocked.id
        end

        def new_integer_value(attr)
          d = journal.detail_for_attribute(attr)
          return nil unless d
          d.value.to_i
        end

        def status_changed_to_closed?
          sid = new_integer_value('status_id')
          sid ? IssueStatus.find(sid).is_closed : false
        end
      end
    end
  end
end
