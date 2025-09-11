# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Runners
      class Base < ::Avm::Runners::Base
        require_sub __FILE__

        runner_with :help, :subcommands do
          desc 'Ruby utilities for AVM.'
          subcommands
        end
      end
    end
  end
end
