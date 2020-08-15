# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  class PluginsTest
    class RakeTaskTest < ::EacRedmineBase0::PluginsTest::BaseTest
      def test_task?
        ::Rake::Task.task_defined?(test_task_name)
      end

      def test_task_name
        "#{plugin.id}:test"
      end

      private

      def run_test_command
        plugin.rails_gem.bundle('exec', 'rake', test_task_name).envvar('RAILS_ENV', 'test')
      end

      def test_result_uncached
        return ::Avm::Result.neutral("task \"#{test_task_name}\" not found") unless test_task?

        super
      end
    end
  end
end
