# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  class PluginsTest
    class UnmaintenedStubTest < ::EacRedmineBase0::PluginsTest::BaseTest
      private

      def test_result_uncached
        ::Avm::Result.neutral('not maintained by E.A.C.')
      end
    end
  end
end
