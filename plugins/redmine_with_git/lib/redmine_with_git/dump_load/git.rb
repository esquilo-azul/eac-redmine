# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module Git
      private

      def repositories_path
        ::RedmineGitHosting::Config.gitolite_global_storage_dir
      end

      def sudo_command
        ::RedmineGitHosting::Commands.send(:sudo)
      end
    end
  end
end
