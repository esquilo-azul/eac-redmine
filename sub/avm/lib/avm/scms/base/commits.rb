# frozen_string_literal: true

module Avm
  module Scms
    class Base
      module Commits
        # @return [Avm::Scms::Commit,NilClass]
        def commit_if_change(_message = nil)
          raise_abstract_method __method__
        end

        # @return [Avm::Scms::Commit]
        def head_commit
          raise_abstract_method __method__
        end

        # @param commit_to_reset [Avm::Scms::Commit]
        # @param commit_info [Avm::Scms::CommitInfo]
        # @return [Avm::Scms::Commit]
        def reset_and_commit(_commit_to_reset, _commit_info)
          raise_abstract_method __method__
        end

        # @param commit_info [Avm::Scms::CommitInfo]
        # @return [Avm::Scms::Commit]
        def run_commit(_commit_info)
          raise_abstract_method __method__
        end
      end
    end
  end
end
