# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  class PluginsTest
    class BaseTest
      enable_simple_cache
      common_constructor :plugin

      def stderr_log
        log_path('stderr')
      end

      def stdout_log
        log_path('stdout')
      end

      def test_name
        self.class.name.demodulize.gsub(/Test\z/, '').underscore
      end

      def to_s
        "#{plugin.id}/#{test_name}"
      end

      private

      def log_path(suffix)
        r = ::Rails.root.join('log', 'eac_redmine_base0',
                              "#{plugin.id}_#{self.class.name.demodulize.underscore}_#{suffix}.log")
        ::FileUtils.mkdir_p(::File.dirname(r))
        r
      end

      def run_test_uncached
        r = run_test_command.execute
        ::File.write(stderr_log, r.fetch(:stderr))
        ::File.write(stdout_log, r.fetch(:stdout))
        r.fetch(:exit_code).zero?
      end

      def test_result_uncached
        ::Avm::Result.success_or_error(
          run_test, 'success', "failed (Log: #{stdout_log})"
        )
      end
    end
  end
end
