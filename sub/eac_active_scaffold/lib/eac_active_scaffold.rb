# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

module EacActiveScaffold
end

require 'eac_rails_utils'
require 'active_scaffold'
require 'recordselect'

require 'eac_active_scaffold/engine'
