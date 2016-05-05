module EacBase
  module Patches
    module JournalPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          after_create :journal_create_event
        end
      end

      module InstanceMethods
        def journal_create_event
          return unless journalized_type == 'Issue'
          EacBase::EventManager.trigger(Issue, :update, self)
        end
      end
    end
  end
end

unless Journal.included_modules.include? EacBase::Patches::JournalPatch
  Journal.send(:include, EacBase::Patches::JournalPatch)
end
