# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  class PluginsTest
    class RubocopTest < ::EacRedmineBase0::PluginsTest::BaseTest
      EXEC_NAME = GEM_NAME = 'rubocop'

      def rubocop?
        return false unless plugin.plugin_gem.gemfile_path.exist?

        bundle_install_command.execute!
        plugin.plugin_gem.gemfile_lock_gem_version(GEM_NAME).present?
      end

      private

      def bundle_install_command
        plugin.plugin_gem.bundle.chdir_root
      end

      def run_test_command
        plugin.plugin_gem.bundle('exec', EXEC_NAME, '--ignore-parent-exclusion')
              .envvar('RAILS_ENV', 'test')
              .chdir_root
      end

      def test_result_uncached
        return ::Avm::Result.neutral("gem \"#{GEM_NAME}\"not found") unless rubocop?

        super
      end
    end
  end
end
