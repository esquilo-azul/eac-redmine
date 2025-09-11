# frozen_string_literal: true

module Avm
  module Sources
    class Base
      class UpdateSub
        enable_method_class

        common_constructor :source, :sub

        def result
          update_version
          return unless sub.organizational?

          sub.update
        end

        private

        def update_version
          base_commit = source.scm.head_commit
          sub.scm.update
          on_update_version_commit_change(base_commit) unless base_commit == source.scm.head_commit
        end

        def on_update_version_commit_change(base_commit)
          source.on_sub_updated if no_scm_updated?
          source.scm.reset_and_commit(base_commit, update_version_commit_info)
        end

        def no_scm_updated?
          source.scm.head_commit.no_scm_changed_files.any?
        end

        # @param commit_info [Avm::Scms::CommitInfo]
        def update_version_commit_info
          Avm::Scms::CommitInfo.new.message(
            no_scm_updated? ? update_version_no_scm_message : update_version_scm_message
          )
        end

        # @return [String]
        def update_version_no_scm_message
          source.i18n_translate(__method__, application_id: sub.application_id,
                                            path: sub.relative_path, version: sub.version)
        end

        # @return [String]
        def update_version_scm_message
          sub.scm.i18n_translate(__method__)
        end
      end
    end
  end
end
