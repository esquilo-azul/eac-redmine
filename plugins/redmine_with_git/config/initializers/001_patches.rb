# frozen_string_literal: true

apply_patches_version_limit = ::Gem::Version.new('4.0.0')
redmine_git_hosting_version = ::Gem::Version.new(
  ::Redmine::Plugin.registered_plugins[:redmine_git_hosting].version
)

return unless redmine_git_hosting_version < apply_patches_version_limit

require 'redmine_with_git/patches/redmine_git_hosting/cache/database_patch'
require 'redmine_with_git/patches/redmine_git_hosting/commands/git/git_patch'
