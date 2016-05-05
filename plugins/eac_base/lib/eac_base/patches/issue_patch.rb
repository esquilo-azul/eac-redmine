module EacBase
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :issue_create_event
        end
      end

      module InstanceMethods
        def issue_create_event
          EacBase::EventManager.trigger(Issue, :create, self)
        end
      end
    end
  end
end

unless Issue.included_modules.include? EacBase::Patches::IssuePatch
  Issue.send(:include, EacBase::Patches::IssuePatch)
end
