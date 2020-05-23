# frozen_string_literal: true

require 'avm/result'
require 'eac_ruby_gems_utils/gem'
require 'eac_ruby_utils/console/speaker'
require 'eac_ruby_utils/envs'
require 'eac_ruby_utils/simple_cache'

module EacRedmineBase0
  class PluginsTest
    include ::EacRubyUtils::Console::Speaker

    def run
      @plugins = []
      ::Redmine::Plugin.registered_plugins.values.each do |plugin|
        check_plugin(plugin)
      end
      check_results
    end

    def check_plugin(plugin)
      infom "Checking plugin \"#{plugin.id}\"..."
      test_plugin = PluginTest.new(plugin)
      test_plugin.test_result
      infom "Plugin \"#{plugin.id}\" checked"
      @plugins << test_plugin
      results_banner
    end

    def results_banner
      infom 'Plugins\' test results:'
      @plugins.each do |plugin|
        infov "  * #{plugin.id}", plugin.test_result.label
      end
    end

    def plugins_failed
      @plugins.select { |plugin| plugin.test_result.error? }
    end

    def check_results
      if plugins_failed.any?
        fatal_error "Some test did not pass:\n" +
                    plugins_failed.map { |p| "  * #{p.id} (Log: #{p.stdout_log})" }.join("\n")
      else
        success 'All tests passed'
      end
    end

    class PluginTest < ::SimpleDelegator
      include ::EacRubyUtils::SimpleCache

      def initialize(plugin)
        super(plugin)
      end

      def test_task_name
        "#{id}:test"
      end

      def test_task?
        ::Rake::Task.task_defined?(test_task_name)
      end

      def stderr_log
        log_path('stderr')
      end

      def stdout_log
        log_path('stdout')
      end

      def maintained?
        ::EacRedmineBase0.maintained_plugins.any? { |plugin| plugin.id == id }
      end

      private

      def log_path(suffix)
        r = ::Rails.root.join('log', 'eac_redmine_base0', "#{id}_test_#{suffix}.log")
        ::FileUtils.mkdir_p(::File.dirname(r))
        r
      end

      def test_result_uncached
        return ::Avm::Result.neutral('not maintained by E.A.C.') unless maintained?
        return ::Avm::Result.neutral("task \"#{test_task_name}\" not found") unless test_task?

        ::Avm::Result.success_or_error(
          run_test ? 'success' : "failed (Log: #{stdout_log})",
          run_test
        )
      end

      def rails_gem_uncached
        ::EacRubyGemsUtils::Gem.new(::Rails.root)
      end

      def run_test_uncached
        r = run_test_command.execute
        ::File.write(stderr_log, r.fetch(:stderr))
        ::File.write(stdout_log, r.fetch(:stdout))
        r.fetch(:exit_code).zero?
      end

      def run_test_command
        rails_gem.bundle('exec', 'rake', test_task_name).envvar('RAILS_ENV', 'test')
      end
    end
  end
end
