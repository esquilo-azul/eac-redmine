# frozen_string_literal: true

module Avm
  module Patches
    module TestCasePatch
      def self.included(base)
        base.setup { ::RedmineAvm::TestConfig.new.before_each }
      end
    end
  end
end

if Rails.env.test?
  unless ::ActiveSupport::TestCase.included_modules.include? Avm::Patches::TestCasePatch
    ::ActiveSupport::TestCase.include Avm::Patches::TestCasePatch
  end
end
