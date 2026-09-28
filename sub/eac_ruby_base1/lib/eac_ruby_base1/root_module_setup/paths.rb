# frozen_string_literal: true

module EacRubyBase1
  class RootModuleSetup
    module Paths
      # @!attribute [r] root_module_file
      # @return [Pathname] Absolute path to the gem's module root file.

      attr_reader :root_module_file

      # @return [Pathname]
      def relative_root_module_file
        count = 0
        current = root_module_file.basename('.*')
        dirname = root_module_file.dirname
        loop do
          ibr if dirname.root?

          break current if dirname.basename.to_path == LIB_DIRECTORY_BASENAME

          current = dirname.basename.join(current)
          dirname = dirname.dirname

          count += 1
        end
      end

      # @return [Pathname]
      def root_module_directory
        root_module_file.basename('.*').expand_path(root_module_file.dirname)
      end

      protected

      attr_writer :root_module_file
    end
  end
end
