# frozen_string_literal: true

module RedmineTasksScheduler
  module Patches
    module TasksSchedulerControllerPatch
      def self.included(base)
        base.const_set('PERMISSIONS', 'scheduled_tasks')
        base.class_eval do
          unloadable

          require_permission const_get('PERMISSIONS')
          layout 'admin'
          helper :scheduled_tasks
          helper :tasks_scheduler
        end
      end
    end
  end
end

return unless ::RedminePluginsHelper::Available.settings?

[::ScheduledTasksController, ::TasksSchedulerDaemonController].each do |controller_class|
  patch_class = ::RedmineTasksScheduler::Patches::TasksSchedulerControllerPatch
  unless controller_class.included_modules.include?(patch_class)
    controller_class.send(:include, patch_class)
  end
end
