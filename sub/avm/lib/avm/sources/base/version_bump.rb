# frozen_string_literal: true

module Avm
  module Sources
    class Base
      module VersionBump
        # @return [Avm::Scms::Commit, nil]
        def version_bump(target_version)
          scm.commit_if_change(version_bump_commit_message(target_version)) do
            version_bump_do_changes(target_version)
            parent.if_present(&:on_sub_updated)
          end
        end

        # @return [String]
        def version_bump_commit_message(target_version)
          i18n_translate(__method__, version: target_version, __locale: locale)
        end

        def version_bump_do_changes(_target_version)
          raise_abstract_method(__method__)
        end
      end
    end
  end
end
