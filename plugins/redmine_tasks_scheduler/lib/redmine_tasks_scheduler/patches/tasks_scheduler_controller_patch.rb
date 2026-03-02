# frozen_string_literal: true

require 'redmine_tasks_scheduler/permissions'

module RedmineTasksScheduler
  module Patches
    module TasksSchedulerControllerPatch
      def self.included(base)
        base.const_set('PERMISSIONS', ::RedmineTasksScheduler::Permissions::WRITE)
        base.class_eval do
          require_permission const_get('PERMISSIONS')
          layout 'nonproject_modules'
          helper :scheduled_tasks
        end
      end
    end
  end
end

return unless RedminePluginsHelper::Available.database_schema?

[ScheduledTasksController, ScheduledTaskStatusesController, TasksSchedulerDaemonController]
  .each do |controller_class|
  patch_class = RedmineTasksScheduler::Patches::TasksSchedulerControllerPatch
  controller_class.send(:include, patch_class) unless controller_class.include?(patch_class)
end
