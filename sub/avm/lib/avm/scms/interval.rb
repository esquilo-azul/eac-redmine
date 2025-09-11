# frozen_string_literal: true

module Avm
  module Scms
    class Interval
      enable_abstract_methods

      common_constructor :scm, :from, :to

      # @return [Array<Avm::Scms::Commit>]
      def commits
        raise_abstract_method __method__
      end
    end
  end
end
