# frozen_string_literal: true

require 'eac_ruby_utils'
require 'eac_rails_utils'
require 'active_scaffold'
require 'recordselect'
require 'eac_active_scaffold/patches'

module EacActiveScaffold
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper
  end
end
