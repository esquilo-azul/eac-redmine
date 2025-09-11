# frozen_string_literal: true

module Avm
  module Scms
    class Base
      module Milestones
        # @return [Avm::Scms::Interval]
        def current_milestone_interval
          interval(current_milestone_base_commit, head_commit)
        end

        # @return [Avm::Scms::Commit]
        def current_milestone_base_commit
          raise_abstract_method __method__
        end
      end
    end
  end
end
