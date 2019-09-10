# frozen_string_literal: true

module RedmineWithGit
  module Load
    class Files < ::RedmineWithGit::Load::Base
      include ::RedmineWithGit::DumpLoad::Files

      private

      def clear_command
        env.command('rm', '-rf', "#{files_path}/*")
      end

      def load_command
        tar_extract_command(files_path)
      end
    end
  end
end
