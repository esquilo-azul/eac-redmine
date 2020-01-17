module RedmineTasksScheduler
  class Settings
    class << self
      def daemon_autostart
        return false unless settings_table_exist?
        ::Setting.plugin_redmine_tasks_scheduler[:daemon_autostart] == '1'
      end

      private

      def settings_table_exist?
        ::Setting.connection.table_exists? ::Setting.table_name
      end
    end
  end
end
