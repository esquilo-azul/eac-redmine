# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs'
require 'eac_ruby_utils/speaker'

module EacRedmineBase0
  class PluginsTest
    enable_speaker

    def run
      ::EacRubyUtils::Speaker.context.on(::EacCli::Speaker.new) do
        @tests = []
        ::Redmine::Plugin.registered_plugins.each_value do |plugin|
          check_plugin(plugin)
        end
        check_results
      end
    end

    def check_plugin(plugin)
      ::EacRedmineBase0::PluginsTest::Plugin.new(plugin).tests.each { |test| check_test(test) }
    end

    def check_test(test)
      infom "Checking test \"#{test}\"..."
      test.test_result
      infom "Test \"#{test}\" checked"
      @tests << test
      results_banner
    end

    def results_banner
      infom 'Tests\' results:'
      @tests.each do |test|
        infov "  * #{test}", test.test_result.label
      end
    end

    def tests_failed
      @tests.select { |test| test.test_result.error? }
    end

    def check_results
      if tests_failed.any?
        fatal_error "Some test did not pass:\n" +
                    tests_failed.map { |test| "  * #{test} (Log: #{test.stdout_log})" }.join("\n")
      else
        success 'All tests passed'
      end
    end
  end
end
