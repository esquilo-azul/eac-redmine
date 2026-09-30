# frozen_string_literal: true

module EacActiveScaffold
  module Patches
    module ActiveScaffold
      module Assets
        module CssDepsGenerator
          # @return [void]
          def initialize
            super
            @css_path = ::EacActiveScaffold::Assets.output_directory.join('active_scaffold/deps.scss')
          end
        end
      end
    end
  end
end
