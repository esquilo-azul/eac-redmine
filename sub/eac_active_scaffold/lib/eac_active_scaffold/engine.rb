# frozen_string_literal: true

require 'eac_rails_utils'
require 'eac_ruby_utils'
require 'active_scaffold'
require 'dartsass-sprockets'
require 'recordselect'

module EacActiveScaffold
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper
  end
end

require 'eac_active_scaffold/patches'
