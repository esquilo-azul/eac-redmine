# frozen_string_literal: true

require 'tmpdir'

module Avm
  module Rspec
    module Setup
      module Launcher
        def temp_launcher_context(settings_file = nil)
          settings_file ||= temp_file
          ::Avm::Launcher::Context.current = ::Avm::Launcher::Context.new(
            projects_root: ::Dir.mktmpdir, settings_file: settings_file, cache_root: ::Dir.mktmpdir
          )
        end
      end
    end
  end
end
