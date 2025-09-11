# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__ do
  ignore 'patches/eac_config/entry_path'
  ignore 'rspec/shared_examples/*'
end

module Avm
end

require 'eac_docker'
require 'eac_fs'
require 'eac_cli'
require 'eac_config'
require 'rspec'

require 'avm/patches/eac_config/entry_path'
