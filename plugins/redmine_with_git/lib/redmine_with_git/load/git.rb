# frozen_string_literal: true

module RedmineWithGit
  module Load
    class Git < ::RedmineWithGit::Load::Base
      include ::RedmineWithGit::DumpLoad::Git

      private

      def clear_command
        env.command('rm', '-rf', "#{repositories_path}/*").prepend(sudo_command)
      end

      def run_load
        env.command('mkdir', '-p', repositories_path).prepend(sudo_command).execute!
        super
      end

      def load_command
        tar_extract_command(repositories_path).prepend(sudo_command)
      end
    end
  end
end
