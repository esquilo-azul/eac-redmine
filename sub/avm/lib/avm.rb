# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

module Avm
end

require 'eac_fs'

require 'avm/patches/eac_config/entry_path'
require 'avm/applications/base'
