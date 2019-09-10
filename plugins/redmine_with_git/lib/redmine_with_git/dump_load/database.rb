# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module Database
      def database_schema
        Rails.configuration.database_configuration[Rails.env]
      end

      def password_arg
        '@ESC_PGPASSWORD=' + Shellwords.escape(database_schema['password'])
      end
    end
  end
end
