# frozen_string_literal: true

module EacRubyBase1
  class RootModuleSetup
    module Patches
      # @return [Enumerable<Pathname>]
      def patches_files
        root_module_directory.join('patches').glob('**/*.rb')
      end

      # @return [void]
      def require_patches
        patches_files.each do |absolute_path|
          require_patch(absolute_path)
        end
      end
    end
  end
end
