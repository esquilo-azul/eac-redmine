# frozen_string_literal: true

module Avm
  module FileFormats
    class SearchFormatter
      include ::EacFs::Traversable

      enable_simple_cache
      enable_speaker
      enable_listable
      lists.add_symbol :option, :apply, :recursive, :verbose
      common_constructor :source_paths, :options, default: [{}] do
        options.assert_valid_keys(self.class.lists.option.values)
      end

      def run
        clear
        search_files
        apply
        show_results
      end

      private

      def apply
        speak(:infom, "Applying #{@formats_files.count} format(s)... ")
        @formats_files.each do |format, files|
          speak(:infom, "Applying format #{format.name} (Files matched: #{files.count})...")
          next unless options[OPTION_APPLY]

          @result += format.apply(files)
        end
      end

      def traverser_check_file(file)
        format = find_format(file)
        speak(:infov, file, format ? format.class : '-')
        return unless format

        @formats_files[format] ||= []
        @formats_files[format] << file
      end

      def clear
        @formats_files = {}
        @result = []
      end

      # @return [Avm::FileFormats::Base, nil]
      def find_format(file)
        ::Avm::Registry.file_formats.detect_optional(file)
      end

      def search_files
        speak(:infov, 'Directories to search', source_paths.count)
        source_paths.each do |source_path|
          speak(:infom, "Searching files on \"#{source_path}\"...")
          traverser_check_path(source_path)
        end
      end

      def show_results
        changed = @result.select(&:changed)
        changed.each do |h|
          speak(:out, h.file.to_s.cyan)
          speak(:out, " (#{h.format})".yellow)
          speak(:puts, ' changed'.green)
        end
        speak(:infov, 'Files changed', "#{changed.count}/#{@result.count}")
      end

      def traverser_recursive
        options[OPTION_RECURSIVE]
      end

      def speak(method, *method_args)
        return unless options[OPTION_VERBOSE].to_bool

        send(method, *method_args)
      end
    end
  end
end
