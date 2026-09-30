# frozen_string_literal: true

module EacRailsGemSupport
  module Rspec
    module Setup
      module FactoryBot
        def setup_factory_bot
          require 'factory_bot_rails'
          rspec_config.include ::FactoryBot::Syntax::Methods
          Spring.after_fork { ::FactoryBot.reload } if defined?(Spring)
          rspec_config.include HelpMethods
          rspec_config.after { ::EacRailsGemSupport::FactoryBot::InstanceRegistry.reset }
        end

        module HelpMethods
          def factory_bot_fetch(key)
            ::EacRailsGemSupport::FactoryBot::InstanceRegistry.fetch(key)
          end
        end
      end
    end
  end
end
