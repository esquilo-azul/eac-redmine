# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module Database
      def build_postgres_command(command, args = [])
        env.command(
          [password_arg, command] + {
            host: database_schema['host'], port: database_schema['port'],
            username: database_schema['username'], dbname: database_schema['database']
          }.flat_map { |k, v| ["--#{k}", v] } + args
        )
      end

      def database_schema
        Rails.configuration.database_configuration[Rails.env]
      end

      def password_arg
        '@ESC_PGPASSWORD=' + Shellwords.escape(database_schema['password'])
      end
    end
  end
end
