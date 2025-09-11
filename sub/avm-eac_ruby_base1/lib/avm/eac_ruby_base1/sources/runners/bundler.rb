# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          require_sub __FILE__
          runner_with :help, :subcommands do
            desc 'Ruby\'s bundler utitilies for local projects.'
            subcommands
          end
        end
      end
    end
  end
end
