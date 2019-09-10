# frozen_string_literal: true

module RedmineWithGit
  module Dump
    class Database < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::Database

      private

      def build_command
        env.command(
          [password_arg, 'pg_dump', '-x', '-c', '-O',
           '-h', database_schema['host'], '-U', database_schema['username'], '-d',
           database_schema['database'], '@ESC_|'] + compress_args
        )
      end
    end
  end
end
