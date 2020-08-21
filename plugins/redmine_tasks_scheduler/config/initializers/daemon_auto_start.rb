# frozen_string_literal: true

if ::RedmineTasksScheduler::Settings.daemon_autostart &&
   ::RedmineNonprojectModules::DispatcherFinder.dispatcher &&
   !::TasksScheduler::Daemon.running?
  ::TasksScheduler::Daemon.execute('start')
end
