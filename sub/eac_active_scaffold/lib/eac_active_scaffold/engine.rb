# frozen_string_literal: true

require 'eac_rails_utils'
require 'eac_ruby_utils'
require 'active_scaffold'
require 'dartsass-sprockets'
require 'recordselect'

module EacActiveScaffold
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper

    initializer 'eac_active_scaffold.assets_output_directory' do |app|
      next unless defined?(Propshaft)

      app.config.assets.paths <<
        ::EacActiveScaffold::Assets.output_directory.to_path
    end
  end
end

require 'eac_active_scaffold/patches'
