# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module Avm
  module Data
    class Rotate
      include ::EacRubyUtils::SimpleCache

      attr_reader :options, :source_path

      def initialize(source_path, options = {})
        @source_path = source_path
        @options = options
      end

      def run
        validate_msg = validate
        return validate_msg if validate_msg.present?

        ::FileUtils.mv(source_path, target_path)
        check_space_limit
        nil
      end

      def space_limit
        r = options[:space_limit].try(:to_i)
        return r if r.present? && r.positive?

        r
      end

      def space_used
        rotated_files.inject(0) { |a, e| a + ::File.size(e) }
      end

      def rotated_files
        ::Dir["#{dirname}/#{source_basename_without_extension}*#{source_extension}"]
      end

      def oldest_rotated_file
        rotated_files.min_by { |file| [::File.mtime(file)] }
      end

      private

      def check_space_limit
        return unless space_limit

        while space_used > space_limit
          file = oldest_rotated_file
          unless file
            raise 'oldest_rotated_file returned nil ' \
                  "(Limit: #{space_limit}, used: #{space_used})"
          end
          ::File.delete(file)
        end
      end

      def validate
        return "Source file \"#{source_path}\" does not exist" unless ::File.exist?(source_path)
        return "File \"#{source_path}\" is already rotated" if source_rotated?

        nil
      end

      def source_rotated?
        source_basename_without_extension.match(/[PN]\d{4}\z/)
      end

      def source_extension_uncached
        file_extension(::File.basename(source_path))
      end

      def source_basename_without_extension
        ::File.basename(source_path, source_extension)
      end

      def target_path_uncached
        ::File.join(dirname, target_basename)
      end

      def dirname
        ::File.dirname(source_path)
      end

      def target_basename
        source_basename_without_extension + target_suffix + source_extension
      end

      def target_suffix
        return '_UNKNOWN_MTIME' unless ::File.exist?(source_path)

        t = ::File.mtime(source_path)
        t.strftime('_%Y-%m-%d_%H-%M-%S_') + t.strftime('%z').gsub(/\A\+/, 'P').gsub(/\A-/, 'N')
      end

      def file_extension(basename)
        extension = ::File.extname(basename)
        return '' if extension.blank?

        file_extension(::File.basename(basename, extension)) + extension
      end
    end
  end
end
