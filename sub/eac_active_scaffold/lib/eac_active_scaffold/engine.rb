# frozen_string_literal: true

require 'eac_rails_utils'
require 'eac_ruby_utils'
require 'active_scaffold'
require 'dartsass-sprockets' unless defined?(Propshaft)
require 'recordselect'

module EacActiveScaffold
  class Engine < ::Rails::Engine
    include ::EacRailsUtils::EngineHelper

    initializer 'eac_active_scaffold.assets_output_directory' do |app|
      next unless defined?(Propshaft)

      app.config.assets.paths <<
        ::EacActiveScaffold::Assets.output_directory.to_path
    end

    initializer 'eac_active_scaffold.patches' do
      ::ActionDispatch::Routing::Mapper.include(::EacActiveScaffold::Patches::ActionDispatch)
      ::ActiveScaffold::Assets::CssDepsGenerator.prepend(::EacActiveScaffold::Patches::ActiveScaffold::Assets::CssDepsGenerator)
      ::ActiveScaffold::Assets::JqueryUiThemeGenerator.prepend(::EacActiveScaffold::Patches::ActiveScaffold::Assets::JqueryUiThemeGenerator)
    end
  end
end
