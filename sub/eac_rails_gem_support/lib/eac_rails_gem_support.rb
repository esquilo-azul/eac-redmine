# frozen_string_literal: true

require 'eac_ruby_base1'
EacRubyBase1::RootModuleSetup.perform __FILE__ do
  ignore 'rspec/shared_examples/**/*'
  require 'avm/eac_ruby_base1'
  require 'capybara'
  require 'eac_ruby_gem_support'
  require 'eac_templates'
  require 'factory_bot_rails'
end
