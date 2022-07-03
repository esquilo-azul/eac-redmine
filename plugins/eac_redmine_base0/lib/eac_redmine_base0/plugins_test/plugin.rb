# frozen_string_literal: true

require 'avm/eac_redmine_base0/sources/base'
require 'avm/eac_redmine_plugin_base0/sources/base'
require 'avm/result'
require 'eac_ruby_utils/simple_cache'

module EacRedmineBase0
  class PluginsTest
    class Plugin < ::SimpleDelegator
      include ::EacRubyUtils::SimpleCache

      def initialize(plugin)
        super(plugin)
      end

      def maintained?
        ::EacRedmineBase0.maintained_plugins.any? { |plugin| plugin.id == id }
      end

      def tests
        return [test_by_type(:unmaintened_stub)] unless maintained?

        [test_by_type(:rake_task), test_by_type(:rubocop)]
      end

      private

      def test_by_type(type)
        ::EacRedmineBase0::PluginsTest.const_get(type.to_s.camelize + 'Test').new(self)
      end

      def plugin_gem_uncached
        ::Avm::EacRedminePluginBase0::Sources::Base.new(directory)
      end

      def rails_gem_uncached
        ::Avm::EacRedmineBase0::Sources::Base.new(::Rails.root)
      end
    end
  end
end
