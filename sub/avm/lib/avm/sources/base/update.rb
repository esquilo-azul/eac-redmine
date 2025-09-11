# frozen_string_literal: true

module Avm
  module Sources
    class Base
      module Update
        # To override in subclasses.
        def on_sub_updated
          # Do nothing
        end

        def update
          update_self
          update_subs
        end

        def update_self
          scm.commit_if_change(-> { update_self_commit_message }) do
            update_self_content
            parent.if_present(&:on_sub_updated)
          end
        end

        # Update source self content.
        #
        # To override in subclasses.
        def update_self_content
          # Do nothing
        end

        def update_self_commit_message
          i18n_translate(__method__)
        end
      end
    end
  end
end
