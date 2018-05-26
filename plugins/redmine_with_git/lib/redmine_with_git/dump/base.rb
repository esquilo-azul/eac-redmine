module RedmineWithGit
  module Dump
    class Base < ::RedmineWithGit::DumpLoad::Base
      def initialize(path, overwrite)
        @overwrite = overwrite
        super(path)
      end

      private

      attr_reader :overwrite

      def run
        start_banner
        if ::File.exist?(path) && !overwrite
          Rails.logger.warn "File \"#{path}\" already exists"
          return
        end
        run_command
        validate_exported
        end_banner
      end

      def start_banner
        Rails.logger.info "Dumping resource \"#{resource_name}\" to \"#{path}\"..."
      end

      def end_banner
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def run_command
        build_command.execute!(output_file: path)
      end

      def create_tar_command(dir, compression = true)
        tar = "cd #{Shellwords.escape(dir)}; tar -c *"
        tar << " | #{compress_args.join(' ')}" if compression
        env.command(['bash', '-c', tar])
      end

      def compress_args
        %w(gzip -9 -c -)
      end

      def validate_exported
        fail "File \"#{path}\" was not generated" unless ::File.exist?(path)
        fail "File \"#{path}\" has zero size" unless ::File.size(path) > 0
      end
    end
  end
end
