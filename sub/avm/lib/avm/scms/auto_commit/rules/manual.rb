# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      module Rules
        class Manual < ::Avm::Scms::AutoCommit::Rules::Base
          class WithFile < ::Avm::Scms::AutoCommit::Rules::Base::WithFile
            enable_speaker

            SKIP_OPTION = 's'

            def commit_info
              return nil unless file.commits.any?

              commits_banner
              input('Which commit?', list: commits_by_position).if_present do |v|
                new_commit_info.fixup(v)
              end
            end

            def commits_banner
              file.commits.each_with_index do |commit, _index|
                infov "    #{commit.position}", commit
              end
              infov "    #{SKIP_OPTION}", 'skip'
            end

            def commits_by_position
              (file.commits.map { |commit| [commit.position.to_s, commit] } + [[SKIP_OPTION, nil]])
                .to_h
            end
          end
        end
      end
    end
  end
end
