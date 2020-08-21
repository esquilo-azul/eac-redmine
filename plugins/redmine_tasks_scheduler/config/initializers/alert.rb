# frozen_string_literal: true

GroupPermission.add_permission('scheduled_tasks')
require_dependency 'redmine_tasks_scheduler/patches/tasks_scheduler_controller_patch'
Redmine::MenuManager.map :top_menu do |menu|
  menu.push :tasks_scheduler_alert,
            { controller: 'tasks_scheduler_daemon', action: 'index', id: nil },
            caption: '', last: true, if: proc { GroupPermission.permission?('scheduled_tasks') }
end
