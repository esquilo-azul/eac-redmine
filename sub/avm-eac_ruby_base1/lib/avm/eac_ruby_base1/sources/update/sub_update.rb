# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Update
        class SubUpdate
          enable_simple_cache
          enable_speaker
          common_constructor :source_update, :sub do
            perform
          end
          delegate :source, to: :source_update

          protected

          def on_scm_updated(commit)
            if commit.no_scm_changed_files.any?
              commit = commit.reword(no_scm_update_commit_message)
              source.scm.commit_if_change { source_update.bundle_update }
                .if_present { |v| v.merge_with(commit) }
            else
              commit.reword(scm_update_commit_message)
            end
          end

          def perform
            update_scm.if_present { |commit| on_scm_updated(commit) }
          end

          # @return [Avm::EacRubyBase1::Sources::Base]
          def ruby_gem_uncached
            ::Avm::EacRubyBase1::Sources::Base.new(sub.path)
          end

          def no_scm_update_commit_message
            source_update.i18n_translate(__method__, __locale: source.locale,
                                                     name: ruby_gem.gem_name,
                                                     version: ruby_gem.version)
          end

          def scm_update_commit_message
            source_update.i18n_translate(__method__, __locale: source.locale)
          end

          # @return [Avm::Scms::Commit]
          def update_scm
            infom "Updating \"#{sub}\"..."
            source.scm.commit_if_change do
              sub.scm.update
            end
          end
        end
      end
    end
  end
end
