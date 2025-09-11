# frozen_string_literal: true

module Avm
  module Scms
    class Base
      module Branches
        # @return [Avm::Scms::Remote]
        def default_remote
          raise_abstract_method __method__
        end

        # @param id [String]
        # @return [Avm::Scms::Remote, nil]
        def remote(id) # rubocop:disable Lint/UnusedMethodArgument
          raise_abstract_method __method__
        end
      end
    end
  end
end
