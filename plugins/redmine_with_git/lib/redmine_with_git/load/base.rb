# frozen_string_literal: true

module RedmineWithGit
  module Load
    class Base < ::RedmineWithGit::DumpLoad::Base
      private

      def run
        start_banner
        unless ::File.exist?(path)
          Rails.logger.warn "File \"#{path}\" does not exist"
          return
        end
        run_clear
        run_load
        end_banner
      end

      def start_banner
        Rails.logger.info "Loading \"#{path}\" to #{resource_name}..."
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def run_clear
        Rails.logger.info "Clearing resource \"#{resource_name}\"..."
        before_clear
        clear_command.execute!
      end

      def run_load
        Rails.logger.info "Loading \"#{path}\" to resource \"#{resource_name}\"..."
        load_command.execute!(input_file: path)
        after_load
      end

      def end_banner
        Rails.logger.info "\"#{path}\" loaded in resource \"#{resource_name}\""
      end

      def uncompress_args
        ['gzip', '-d', '-c', '-']
      end

      def tar_extract_command(target_dir, compression = true)
        env.command('tar', (compression ? '-xz' : '-x'), '-C', target_dir)
      end

      def before_clear; end

      def after_load; end
    end
  end
end
