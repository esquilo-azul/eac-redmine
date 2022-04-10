# frozen_string_literal: true

module RedmineWithGit
  module Dump
    class Database < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::Database

      private

      def build_command
        build_postgres_command('pg_dump', ['-x', '-c', '-O', '@ESC_|'] + compress_args)
      end
    end
  end
end
