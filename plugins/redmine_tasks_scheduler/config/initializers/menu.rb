# frozen_string_literal: true

require_dependency 'redmine_tasks_scheduler/patches/tasks_scheduler_controller_patch'
GroupPermission.add_permission(::ScheduledTasksController::PERMISSIONS)
Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :scheduled_tasks, { controller: 'scheduled_tasks', action: 'status', id: nil },
            caption: :'activerecord.models.scheduled_task.other',
            if: proc { GroupPermission.permission?(::ScheduledTasksController::PERMISSIONS) }
end
