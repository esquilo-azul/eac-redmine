# frozen_string_literal: true

module RedmineTasksScheduler
  class Settings
    class << self
      def daemon_autostart # rubocop:disable Naming/PredicateMethod
        return false unless ::RedminePluginsHelper::Available.settings?

        ::Setting.plugin_redmine_tasks_scheduler[:daemon_autostart] == '1'
      end
    end
  end
end
