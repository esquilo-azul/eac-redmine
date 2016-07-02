namespace :redmine_git_hosting do
  desc 'Executa as operações de "Rescue" da configuração do plugin RedmineGitHosting'
  task rescue: :environment do |_t, _args|
    GitoliteAccessor.update_projects(
      'all',
      message: 'Forced resync of all projects (active, closed, archived)...',
      force: true
    )
    GitoliteAccessor.resync_ssh_keys
    GitoliteAccessor.flush_git_cache
  end
end
