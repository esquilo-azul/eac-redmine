# frozen_string_literal: true

module EacFs
  class Logs
    class File
      enable_simple_cache
      common_constructor :label

      TRUNCATE_DEFAULT_LENGTH = 1000
      TRUNCATE_APPEND_TEXT = '(...) '

      delegate :remove, to: :file

      def clean
        file.truncate(0) if file.exist?
      end

      def file_size
        file.file? ? file.size : 0
      end

      def pretty_file_size
        ::Filesize.from("#{file_size} B").pretty
      end

      # @param length [Integer]
      # @return [String]
      def truncate(length = TRUNCATE_DEFAULT_LENGTH)
        content = file.file? ? file.read.strip : ''
        return content if content.length <= TRUNCATE_DEFAULT_LENGTH

        TRUNCATE_APPEND_TEXT + content[content.length - length + TRUNCATE_APPEND_TEXT.length,
                                       length - TRUNCATE_APPEND_TEXT.length]
      end

      # @param length [Integer]
      # @return [String]
      def truncate_with_label(length = TRUNCATE_DEFAULT_LENGTH)
        header = [label, file, pretty_file_size].join(' / ')
        return ">>> #{header} (Not found) <<<" unless file.file?

        content = truncate(length)
        content.blank? ? ">>> #{header} (Blank) <<<" : ">>> #{header}\n#{content}\n<<< #{header}\n"
      end

      protected

      # @return [EacRubyUtils::Fs::Temp::File
      def file_uncached
        ::EacRubyUtils::Fs::Temp.file
      end
    end
  end
end
