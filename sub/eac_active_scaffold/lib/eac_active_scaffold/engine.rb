# frozen_string_literal: true

require 'active_scaffold'
require 'eac_active_scaffold/patches'
require 'eac_rails_utils/engine_helper'
require 'recordselect'

module EacActiveScaffold
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper
  end
end
