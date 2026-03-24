# frozen_string_literal: true

module RedmineAvm
  module Patches
    module TestCasePatch
      def self.included(base)
        base.setup { ::RedmineAvm::TestConfig.new.before_each }
      end
    end
  end
end

if Rails.env.test? &&
   !ActiveSupport::TestCase.include?(RedmineAvm::Patches::TestCasePatch) # rubocop:disable Rails/NegateInclude
  ActiveSupport::TestCase.include RedmineAvm::Patches::TestCasePatch # rubocop:disable Rails/ActiveSupportOnLoad
end
