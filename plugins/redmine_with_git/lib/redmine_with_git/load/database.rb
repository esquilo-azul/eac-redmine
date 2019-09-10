# frozen_string_literal: true

require_dependency 'redmine_plugins_helper'

module RedmineWithGit
  module Load
    class Database < ::RedmineWithGit::Load::Base
      include ::RedmineWithGit::DumpLoad::Database

      private

      def before_clear
        raise(<<~MESSAGE) unless ::RedminePluginsHelper.settings_table_exist?
          Settings table does not exist.
        MESSAGE

        @redmine_git_hosting_setting = ::Setting.plugin_redmine_git_hosting
      end

      def clear_command
        psql_sql_command(psql_sql_command(drop_all_tables_sql).execute!)
      end

      def load_command
        psql_command.prepend(uncompress_args + ['@ESC_|'])
      end

      def after_load
        ::Setting.plugin_redmine_git_hosting = @redmine_git_hosting_setting if
        @redmine_git_hosting_setting
      end

      def psql_command
        env.command(
          [password_arg, 'psql',
           '-h', database_schema['host'], '-U', database_schema['username'], '-d',
           database_schema['database']]
        )
      end

      def psql_sql_command(sql)
        psql_command.append(['-qtc', sql])
      end

      def drop_all_tables_sql
        "select 'drop table \"' || tablename || '\" cascade;' from pg_tables " \
          "where schemaname = 'public';"
      end
    end
  end
end
