# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      class ForFile
        enable_speaker
        enable_simple_cache
        enable_listable

        common_constructor :scm, :path, :rules do
          self.path = path.to_pathname.expand_path(scm.path)
        end

        COMMITS_SEARCH_INTERVAL = 'origin/master..HEAD'

        def scm_relative_path
          path.to_pathname.relative_path_from(scm.path)
        end

        def run
          start_banner
          run_commit || warn("No rule returned commit information for \"#{path}\"")
        end

        private

        # @return [Boolean]
        def changed?
          scm.changed_files.any? { |cf| cf.path == scm_relative_path }
        end

        def commit_info_uncached
          rules.lazy.map { |rule| rule.with_file(self).commit_info }.find(&:present?)
            .if_present { |v| v.path(path) }
        end

        def start_banner
          infov 'Path', path
          infov '  Commits found', commits.count
        end

        def run_commit # rubocop:disable Naming/PredicateMethod
          return false if commit_info.blank?

          infov '  Commit info', commit_info
          if changed?
            scm.run_commit(commit_info)
            success '  Commited'
          else
            warn "  File \"#{path}\" unchanged"
          end

          true
        end

        def commits_uncached
          scm.current_milestone_interval.commits
            .select { |c| c.changed_files.include?(path.relative_path_from(scm.path)) }
            .reject(&:fixup?).each_with_index
            .map { |commit, index| CommitDelegator.new(commit, index) }
        end

        class CommitDelegator < ::SimpleDelegator
          attr_reader :index

          def initialize(commit, index)
            super(commit)
            @index = index
          end

          def position
            index + 1
          end
        end
      end
    end
  end
end
