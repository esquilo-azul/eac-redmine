# frozen_string_literal: true

require 'redmine'
require 'active_scaffold'
ActiveScaffold.delayed_setup = true

Redmine::Plugin.register :redmine_tasks_scheduler do
  name 'Redmine Tasks Scheduler'
  author 'eduardobogoni@gmail.com'
  description 'Scheduler for rake tasks on Redmine.'
  version '0.2.2'
  settings default: { 'daemon_autostart' => '1' }, partial: 'settings/redmine_tasks_scheduler'
end

Rails.configuration.to_prepare do
  GroupPermission.add_permission('scheduled_tasks')
  require_dependency 'redmine_tasks_scheduler/patches/tasks_scheduler_controller_patch'
  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :scheduled_tasks, { controller: 'scheduled_tasks', action: 'status', id: nil },
              caption: :'activerecord.models.scheduled_task.other',
              if: proc { GroupPermission.permission?('scheduled_tasks') }
  end
end
