# frozen_string_literal: true

require 'eac_cli/core_ext'
require 'clipboard'

module Avm
  module Sources
    module Issues
      class Deliver
        enable_simple_cache
        enable_speaker

        common_constructor :scm
        delegate :head_branch, to: :scm

        def run # rubocop:disable Naming/PredicateMethod
          push
          clipboard_copy_tracker_message
          true
        end

        def start_banner
          infov 'Branch ID', branch_id
          infov 'Commit ID', branch_commit_id
        end

        private

        def branch_commit_id
          head_branch.head_commit.id
        end

        def branch_id
          head_branch.id
        end

        def clipboard_copy_tracker_message
          ::Clipboard.copy(textile_tracker_message)
          infov 'Copied to clipboard', textile_tracker_message
        end

        def push
          head_branch.push(scm.default_remote)
        end

        def textile_tracker_message
          "#{branch_id}: commit:#{branch_commit_id}."
        end
      end
    end
  end
end
