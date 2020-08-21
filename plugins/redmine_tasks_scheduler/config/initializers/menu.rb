# frozen_string_literal: true

GroupPermission.add_permission('scheduled_tasks')
require_dependency 'redmine_tasks_scheduler/patches/tasks_scheduler_controller_patch'
Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :scheduled_tasks, { controller: 'scheduled_tasks', action: 'status', id: nil },
            caption: :'activerecord.models.scheduled_task.other',
            if: proc { GroupPermission.permission?('scheduled_tasks') }
end
