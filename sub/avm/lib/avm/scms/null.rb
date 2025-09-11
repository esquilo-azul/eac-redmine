# frozen_string_literal: true

module Avm
  module Scms
    class Null < ::Avm::Scms::Base
      # @return [Avm::Scms::Null::Commit]
      def head_commit
        @head_commit ||= Avm::Scms::Null::Commit.new(self)
      end

      def update
        # Do nothing
      end
    end
  end
end
