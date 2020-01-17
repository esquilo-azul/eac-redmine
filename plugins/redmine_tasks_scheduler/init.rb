# coding: utf-8

require 'redmine'
require 'active_scaffold'
ActiveScaffold.delayed_setup = true

Redmine::Plugin.register :redmine_tasks_scheduler do
  name 'Redmine Tasks Scheduler'
  author 'eduardobogoni@gmail.com'
  description 'Scheduler for rake tasks on Redmine.'
  version '0.2.0'
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
  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :tasks_scheduler_alert,
              { controller: 'tasks_scheduler_daemon', action: 'index', id: nil },
              caption: '', last: true, if: proc { GroupPermission.permission?('scheduled_tasks') }
  end
  if ::RedmineTasksScheduler::Settings.daemon_autostart &&
     ::RedmineNonprojectModules::DispatcherFinder.dispatcher &&
     !::TasksScheduler::Daemon.running?
    ::TasksScheduler::Daemon.execute('start')
  end
end
