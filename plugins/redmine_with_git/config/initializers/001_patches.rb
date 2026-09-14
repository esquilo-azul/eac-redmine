# frozen_string_literal: true

EacRubyUtils.patch_module(
  RedmineGitHosting::GitoliteHook,
  RedmineWithGit::Patches::RedmineGitHosting::GitoliteHook
)

apply_patches_version_limit = Gem::Version.new('4.0.0')
redmine_git_hosting_version = Gem::Version.new(
  Redmine::Plugin.registered_plugins[:redmine_git_hosting].version
)

return unless redmine_git_hosting_version < apply_patches_version_limit

patch = RedmineWithGit::Patches::RedmineGitHosting::Cache::Database
target = RedmineGitHosting::Cache::Database
target.send(:include, patch) unless target.include?(patch)

patch = RedmineWithGit::Patches::RedmineGitHosting::Commands::Git
target = RedmineGitHosting::Commands::Git
target.send(:include, patch) unless target.include?(patch)
