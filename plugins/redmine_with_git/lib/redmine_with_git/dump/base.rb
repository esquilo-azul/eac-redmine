# frozen_string_literal: true

require 'avm/files/rotate'
require 'eac_ruby_utils/patches/object/asserts'
require 'eac_ruby_utils/listable'

module RedmineWithGit
  module Dump
    class Base < ::RedmineWithGit::DumpLoad::Base
      include ::EacRubyUtils::Listable

      lists.add_integer :overwrite, 1 => :denied, 2 => :allowed, 3 => :rotate

      attr_reader :options

      def initialize(path, options = {})
        options.assert_argument ::Hash, 'options'
        @options = options
        validate_overwrite
        super(path)
      end

      def overwrite
        v = @options[:overwrite]
        v.present? ? v.to_i : OVERWRITE_DENIED
      end

      def space_limit
        @options[:space_limit]
      end

      private

      def run
        start_banner
        return unless run_if_overwrite_denied
        return unless run_if_rotate

        run_command
        validate_exported
        end_banner
      end

      def start_banner
        Rails.logger.info "Dumping resource \"#{resource_name}\" to \"#{path}\"..."
        Rails.logger.info "Overwrite: #{overwrite}"
      end

      def end_banner
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def run_if_overwrite_denied
        if ::File.exist?(path) && overwrite == OVERWRITE_DENIED
          Rails.logger.warn "File \"#{path}\" already exists"
          false
        else
          true
        end
      end

      def run_if_rotate
        if ::File.exist?(path) && overwrite == OVERWRITE_ROTATE
          rotate = ::Avm::Files::Rotate.new(path, space_limit: space_limit)
          ::Rails.logger.info "Rotating \"#{rotate.source_path}\"..."
          rotate.run
          ::Rails.logger.info "Rotated to \"#{rotate.target_path}\""
        end
        true
      end

      def run_command
        build_command.execute!(output_file: path)
      end

      def create_tar_command(dir, compression = true)
        tar = "cd #{Shellwords.escape(dir)}; tar -c *"
        tar += " | #{compress_args.join(' ')}" if compression
        env.command(['bash', '-c', tar])
      end

      def compress_args
        %w[gzip -9 -c -]
      end

      def validate_exported
        raise "File \"#{path}\" was not generated" unless ::File.exist?(path)
        raise "File \"#{path}\" has zero size" unless ::File.size(path).positive?
      end

      def validate_overwrite
        klass = ::RedmineWithGit::Dump::Base
        return if klass.lists.overwrite.values.include?(overwrite)

        raise "Invalid overwrite value: \"#{overwrite}\" (Valid: #{klass.lists.overwrite.values})"
      end
    end
  end
end
