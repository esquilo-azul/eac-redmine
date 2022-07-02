# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :redmine_tasks_scheduler do
  name 'Redmine Tasks Scheduler'
  author 'eduardobogoni@gmail.com'
  description 'Scheduler for rake tasks on Redmine.'
  version '0.2.3'
  settings default: { 'daemon_autostart' => '1' }, partial: 'settings/redmine_tasks_scheduler'
end
