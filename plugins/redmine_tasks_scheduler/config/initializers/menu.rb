# frozen_string_literal: true

GroupPermission.add_permission(RedmineTasksScheduler::Permissions::WRITE)
Redmine::Plugin.by_path(__FILE__).nonprojects_menu do |menu|
  {
    tasks_scheduler_daemon: { controller: 'tasks_scheduler_daemon', action: 'index', id: nil },
    status_scheduled_tasks: { controller: 'scheduled_tasks', action: 'status', id: nil },
    scheduled_tasks: { controller: 'scheduled_tasks', action: 'index', id: nil }
  }.each do |k, v|
    menu.push k, v,
              caption: :"eac_rails_utils.menus.root.admin.tasks_scheduler.main_app_#{k}",
              if: proc { GroupPermission.permission?(RedmineTasksScheduler::Permissions::WRITE) }
  end
end
