# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacActiveScaffold
  module Rspec
    module Setup
      def self.extended(obj)
        %w[controller_example].each do |m|
          obj.send("setup_#{m}")
        end
      end

      private

      def setup_controller_example
        require 'eac_active_scaffold/rspec/shared_contexts/active_scaffold_controller'
      end
    end
  end
end
