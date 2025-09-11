# frozen_string_literal: true

module Avm
  module FileFormats
    class Utf8Assert
      UTF8_CHARSET = 'utf-8'
      UTF8_CHARSETS = [UTF8_CHARSET, 'us-ascii'].freeze

      class << self
        def assert_files(files)
          asserters = files.map { |file| new(file) }
          begin
            asserters.each(&:assert)
            yield
          ensure
            asserters.each(&:revert)
          end
        end
      end

      enable_simple_cache
      common_constructor :path

      def assert
        return if original_utf8?

        convert_self(original_charset, UTF8_CHARSET)
      end

      def revert
        return if original_utf8?

        convert_self(UTF8_CHARSET, original_charset)
      end

      private

      def original_info_uncached
        ::EacFs::FileInfo.new(path)
      end

      def original_charset_uncached
        return original_info.content_type.charset if original_info.content_type.charset.present?

        raise 'No charset found'
      rescue StandardError => e
        raise "Unable to determine the charset of #{path} (#{e.message})"
      end

      def original_utf8?
        UTF8_CHARSETS.include?(original_charset)
      end

      def convert_file(from_path, from_charset, to_path, to_charset)
        File.open(from_path, "r:#{from_charset}") do |input|
          File.open(to_path, "w:#{to_charset}") do |output|
            output.write(input.read)
          end
        end
      end

      def convert_self(from_charset, to_charset)
        temp = ::Tempfile.new
        temp.close
        convert_file(path, from_charset, temp.path, to_charset)
        ::FileUtils.mv(temp.path, path)
      end
    end
  end
end
