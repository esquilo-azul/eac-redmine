# frozen_string_literal: true

module RedmineTasksScheduler
  module Patches
    module TasksSchedulerControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          require_permission 'scheduled_tasks'
          layout 'admin'
        end
      end
    end
  end
end

[::ScheduledTasksController, ::TasksSchedulerDaemonController].each do |controller_class|
  patch_class = ::RedmineTasksScheduler::Patches::TasksSchedulerControllerPatch
  unless controller_class.included_modules.include?(patch_class)
    controller_class.send(:include, patch_class)
  end
end
