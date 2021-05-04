# frozen_string_literal: true

GroupPermission.add_permission(::ScheduledTasksController::PERMISSIONS)
Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :scheduled_tasks, { controller: 'scheduled_tasks', action: 'status', id: nil },
            caption: :'activerecord.models.scheduled_task.other',
            if: proc { GroupPermission.permission?(::ScheduledTasksController::PERMISSIONS) }
end
