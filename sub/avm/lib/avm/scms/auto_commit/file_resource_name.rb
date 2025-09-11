# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      class FileResourceName
        require_sub __FILE__, include_modules: true
        enable_simple_cache
        common_constructor :scm, :path do
          self.path = path.to_pathname
        end

        def class_name
          file_format.file_resource_name(relative_path)
        end

        def commit_message
          r = class_name
          r += ': *' if modified?
          r += ': remove' unless path.file?
          "#{r}."
        end

        # @return [Boolean]
        def modified?
          dirty_file.if_present(false, &:modify?)
        end

        # @return [Pathname]
        def relative_path
          path.expand_path.relative_path_from(scm.path.expand_path)
        end

        private

        def dirty_file_uncached
          scm.changed_files.find { |e| e.absolute_path == path.expand_path }
        end

        # @return [Avm::FileFormats::Base]
        def file_format_uncached
          ::Avm::Registry.file_formats.detect(path)
        end
      end
    end
  end
end
