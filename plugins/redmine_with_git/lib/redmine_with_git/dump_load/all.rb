# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module All
      DATABASE = 'database.gz'
      FILES = 'files.tar.gz'
      GIT = 'git.tar.gz'

      RESOURCES = %w[database files git].freeze

      private

      attr_reader :tmpdir

      def on_temp_dir
        ::Dir.mktmpdir do |dir|
          @tmpdir = dir
          yield
        end
      end

      def resource_class(resource_name)
        "#{self.class.name.deconstantize}::#{resource_name.camelize}".constantize
      end

      def resource_file_name(resource_name)
        self.class.const_get(resource_name.underscore.upcase)
      end

      def resource_file_path(resource_name)
        File.join(tmpdir, resource_file_name(resource_name))
      end
    end
  end
end
