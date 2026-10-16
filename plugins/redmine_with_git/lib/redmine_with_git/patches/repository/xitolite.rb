# frozen_string_literal: true

module RedmineWithGit
  module Patches
    module Repository
      module Xitolite
        def self.included(base)
          base.prepend(InstanceMethods)
        end

        module InstanceMethods
          # @param prev_db_heads [Array<String>]
          # @param repo_heads [Array<String>]
          # @return [void]
          def save_revisions(prev_db_heads, repo_heads)
            super(prev_db_heads.select { |head| commit_exist?(head) }, repo_heads)
          end

          private

          # @param revision [String]
          # @return [Boolean]
          def commit_exist?(revision)
            scm.rev_parse("#{revision}^{commit}").present?
          end
        end
      end
    end
  end
end
