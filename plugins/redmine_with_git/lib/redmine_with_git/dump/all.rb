# frozen_string_literal: true

module RedmineWithGit
  module Dump
    class All < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::All

      private

      def run_command
        on_temp_dir do
          RESOURCES.each { |resource| build_sub(resource) }
          super
        end
      end

      def build_sub(resource)
        resource_class(resource).new(resource_file_path(resource), options)
      end

      def build_command
        create_tar_command(tmpdir, false)
      end
    end
  end
end
