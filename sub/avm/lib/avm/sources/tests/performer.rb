# frozen_string_literal: true

module Avm
  module Sources
    module Tests
      class Performer
        enable_simple_cache

        common_constructor(:owner)

        def non_failed_units
          units.reject(&:failed?)
        end

        def failed_units
          units.select(&:failed?)
        end

        # @return [Boolean]
        def successful?
          failed_units.none?
        end

        protected

        def units_uncached
          owner.selected_units
        end
      end
    end
  end
end
