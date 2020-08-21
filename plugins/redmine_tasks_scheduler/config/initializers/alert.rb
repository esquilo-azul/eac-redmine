# frozen_string_literal: true

require_dependency 'redmine_tasks_scheduler/patches/tasks_scheduler_controller_patch'
GroupPermission.add_permission(::TasksSchedulerDaemonController::PERMISSIONS)
Redmine::MenuManager.map :top_menu do |menu|
  menu.push :tasks_scheduler_alert,
            { controller: 'tasks_scheduler_daemon', action: 'index', id: nil },
            caption: '', last: true, if: proc { ::TasksSchedulerDaemonController::PERMISSIONS }
end
