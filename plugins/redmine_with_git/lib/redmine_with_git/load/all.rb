# frozen_string_literal: true

module RedmineWithGit
  module Load
    class All < ::RedmineWithGit::Load::Base
      include ::RedmineWithGit::DumpLoad::All

      private

      def run_clear
        # Do nothing
      end

      def run_load
        on_temp_dir do
          extract_path_to_tmpdir
          RESOURCES.each { |r| load_resource(r) }
        end
      end

      def extract_path_to_tmpdir
        tar_extract_command(tmpdir, false).execute!(input_file: path)
      end

      def load_resource(resource_name)
        resource_class(resource_name).new(resource_file_path(resource_name))
      end
    end
  end
end
