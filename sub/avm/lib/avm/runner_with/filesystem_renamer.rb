# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module RunnerWith
    module FilesystemRenamer
      common_concern do
        runner_with :confirmation, :filesystem_traverser
        prepend PrependMethods
      end

      class RenameFile
        enable_speaker
        common_constructor :runner, :file
        delegate :path, :target_path, :valid?, to: :file

        CONFIRM_MESSAGE = 'Rename?'

        def show
          if rename?
            puts [target_path_to_s, '<='.green, path_to_s].join(' ')
          else
            puts path_to_s
          end
        end

        def rename
          return unless rename?

          show
          do_rename if runner.confirm?(CONFIRM_MESSAGE)
        end

        # @return [Boolean]
        def rename?
          path.to_pathname != target_path.to_pathname
        end

        private

        def do_rename
          ::FileUtils.mv(path, target_path)
        end

        # @return [String]
        def path_to_s
          path.basename.to_path.light_black
        end

        # @return [String]
        def target_path_to_s
          target_path.relative_path_from(path.dirname).to_path
        end
      end

      module PrependMethods
        # @param path [Pathname]
        # @return [void]
        def traverser_check_file(path)
          file = RenameFile.new(self, file_class.new(path))
          files << file if file.valid?
        end
      end

      FILE_WRAPPER_CLASS_BASENAME = 'FileWrapper'

      # @return [Class]
      def file_class
        self.class.const_get(FILE_WRAPPER_CLASS_BASENAME)
      end

      # @return [void]
      def run_filesystem_renamer
        self.files = []
        run_filesystem_traverser
        show_files
        rename_files
        success 'Done'
      end

      # @return [void]
      def show_files
        infov 'Files found', files.count
        files.each(&:show)
      end

      # @return [void]
      def rename_files
        return if parsed.no? || files.none?(&:rename?)

        infom 'Renaming files...'
        files.each(&:rename)
      end

      private

      attr_accessor :files
    end
  end
end
