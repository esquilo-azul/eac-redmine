module RedmineWithGit
  module Dump
    class All < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::DumpLoad::All

      private

      def run_command
        on_temp_dir do
          RESOURCES.each { |a| build_sub(a) }
          super
        end
      end

      def build_sub(a)
        resource_class(a).new(resource_file_path(a), overwrite)
      end

      def build_command
        create_tar_command(tmpdir, false)
      end
    end
  end
end
