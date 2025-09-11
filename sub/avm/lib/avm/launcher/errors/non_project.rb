# frozen_string_literal: true

module Avm
  module Launcher
    module Errors
      class NonProject < ::Avm::Launcher::Errors::Base
        def initialize(path)
          super("#{path} is not a project")
        end
      end
    end
  end
end
