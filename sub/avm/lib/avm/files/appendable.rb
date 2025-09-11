# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Files
    module Appendable
      require_sub __FILE__

      attr_reader :variables_source

      def appended
        @appended ||= []
      end

      def append_templatized_directories(directories)
        directories.each { |directory| append_templatized_directory(directory) }
        self
      end

      def append_plain_directory(directory)
        appended << ::Avm::Files::Appendable::PlainDirectory.new(self, directory)
        self
      end

      def append_tar_output_command(tar_command)
        appended << ::Avm::Files::Appendable::TarOutputCommand.new(self, tar_command)
        self
      end

      def append_templatized_directory(directory)
        appended << ::Avm::Files::Appendable::TemplatizedDirectory.new(self, directory)
        self
      end

      def append_file_content(target_path, content)
        appended << ::Avm::Files::Appendable::FileContent
                      .new(self, target_path, content)
        self
      end

      def variables_source_set(source)
        @variables_source = source
        self
      end

      def write_appended_on(target_dir)
        target_dir = target_dir.to_pathname
        raise "\"#{target_dir}\" is not a directory" unless target_dir.directory?

        appended.each { |append| append.write_on(target_dir) }
      end
    end
  end
end
