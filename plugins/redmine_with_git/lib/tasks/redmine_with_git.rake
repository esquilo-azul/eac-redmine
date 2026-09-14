# frozen_string_literal: true

namespace :redmine_with_git do
  desc 'Executa as operações de "Rescue" da configuração do plugin RedmineGitHosting'
  task rescue: %i[redmine_git_hosting:install_hook_parameters
                  redmine_git_hosting:migration_tools:update_repositories_type
                  redmine_git_hosting:install_hook_files
                  redmine_git_hosting:fetch_changesets] do |_t, _args|
    RedmineGitHosting::GitoliteAccessor.update_projects(
      'all',
      message: 'Forced resync of all projects (active, closed, archived)...',
      force: true
    )
    RedmineGitHosting::GitoliteAccessor.resync_ssh_keys
    RedmineGitHosting::GitoliteAccessor.flush_git_cache
  end
end
