# frozen_string_literal: true

module EacActiveScaffold
  module Patches
    module ActiveScaffold
      module Assets
        module JqueryUiThemeGenerator
          # @return [void]
          def initialize
            super
            @theme_path = ::EacActiveScaffold::Assets.output_directory.join('active_scaffold/jquery-ui/theme.css')
          end
        end
      end
    end
  end
end
