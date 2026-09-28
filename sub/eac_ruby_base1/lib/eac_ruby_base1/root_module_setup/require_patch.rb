# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/acts_as_instance_method'
require 'eac_ruby_utils/patches/object/to_pathname'
require 'eac_ruby_utils/patches/pathname/basename_sub'
require 'memoized'

module EacRubyBase1
  class RootModuleSetup
    class RequirePatch
      acts_as_instance_method
      common_constructor :setup, :absolute_path do
        self.absolute_path = absolute_path.to_pathname
      end

      # @return [void]
      def result
        perform_require
        perform_ignore
      end

      # @return [Pathname]
      def ignore_path
        absolute_path.relative_path_from(setup.root_module_directory)
          .basename_sub { |b| b.basename('.*') }
      end

      # @return [void]
      def perform_require
        ::Kernel.require require_path
      end

      # @return [void]
      def perform_ignore
        setup.ignore ignore_path
      end

      # @return [Pathname]
      def require_path
        setup.relative_root_module_file.join(ignore_path)
      end
    end
  end
end
