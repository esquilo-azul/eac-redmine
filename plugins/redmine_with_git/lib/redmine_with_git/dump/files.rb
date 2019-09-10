# frozen_string_literal: true

module RedmineWithGit
  module Dump
    class Files < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::Files

      private

      def build_command
        create_tar_command(files_path)
      end
    end
  end
end
