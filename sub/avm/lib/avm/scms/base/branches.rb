# frozen_string_literal: true

module Avm
  module Scms
    class Base
      module Branches
        # @param id [String]
        # @return [Avm::Scms::Branch, nil]
        def branch(id) # rubocop:disable Lint/UnusedMethodArgument
          raise_abstract_method __method__
        end

        # @return [Avm::Scms::Branch]
        def head_branch
          raise_abstract_method __method__
        end
      end
    end
  end
end
