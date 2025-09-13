# frozen_string_literal: true

module RedmineWithGit
  module Patches
    module RedmineGitHosting
      module Commands
        module GitPatch
          def self.included(base)
            base.prepend(InstanceMethods)
          end
        end

        module InstanceMethods
          def git_version
            sudo_git('--version')
          rescue RedmineGitHosting::Error::GitoliteCommandException => e
            logger.error("Can't retrieve Git version: #{e.output}")
            'unknown'
          end
        end
      end
    end
  end
end

patch = RedmineWithGit::Patches::RedmineGitHosting::Commands::GitPatch
target = RedmineGitHosting::Commands::Git
target.send(:include, patch) unless target.included_modules.include?(patch)
