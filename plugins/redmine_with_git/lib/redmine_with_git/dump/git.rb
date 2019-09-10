# frozen_string_literal: true

module RedmineWithGit
  module Dump
    class Git < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::Git

      private

      def build_command
        create_tar_command(repositories_path).prepend(sudo_command)
      end
    end
  end
end
