# frozen_string_literal: true

module Avm
  module Scms
    class Branch
      acts_as_abstract

      # @return [Avm::Scms::Commit]
      def head_commit
        raise_abstract_method __method__
      end

      # @return [String]
      def id
        raise_abstract_method __method__
      end

      # @param remote [Avm::Scms::Remote]
      def push(remote) # rubocop:disable Lint/UnusedMethodArgument
        raise_abstract_method __method__
      end
    end
  end
end
