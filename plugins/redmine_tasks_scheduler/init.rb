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
