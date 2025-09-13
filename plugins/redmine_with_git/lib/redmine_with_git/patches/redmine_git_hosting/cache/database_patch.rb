# frozen_string_literal: true

module RedmineGitHosting
  module Cache
    module DatabasePatch
      def self.included(base)
        base.prepend(InstanceMethods)
      end

      module InstanceMethods
        def apply_cache_limit
          return unless max_cache_elements >= 0 && GitCache.count > max_cache_elements

          GitCache.order(created_at: :desc).last.destroy
        end
      end
    end
  end
end

patch = RedmineGitHosting::Cache::DatabasePatch
target = RedmineGitHosting::Cache::Database
target.send(:include, patch) unless target.included_modules.include? patch
