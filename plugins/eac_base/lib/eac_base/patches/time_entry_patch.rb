module EacBase
  module Patches
    module TimeEntryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :time_entry_create_event
        end
      end

      module InstanceMethods
        def time_entry_create_event
          EacBase::EventManager.trigger(TimeEntry, :create, self)
        end
      end
    end
  end
end

unless TimeEntry.included_modules.include? EacBase::Patches::TimeEntryPatch
  TimeEntry.send(:include, EacBase::Patches::TimeEntryPatch)
end
