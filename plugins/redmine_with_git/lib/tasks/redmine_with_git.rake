namespace :redmine_with_git do
  %w(database files git all).each do |a|
    namespace :dump do
      task a, [:path, :overwrite] => :environment do |_t, args|
        ::RedmineWithGit::Dump.const_get(a.camelize).new(args.path, args.overwrite.present?)
      end
    end
    namespace :load do
      task a, [:path] => :environment do |_t, args|
        ::RedmineWithGit::Load.const_get(a.camelize).new(args.path)
      end
    end
  end

  desc 'Executa as operações de "Rescue" da configuração do plugin RedmineGitHosting'
  task rescue: [:'redmine_git_hosting:install_hook_parameters',
                :'redmine_git_hosting:migration_tools:update_repositories_type',
                :'redmine_git_hosting:install_hook_files',
                :'redmine_git_hosting:fetch_changesets'] do |_t, _args|
    RedmineGitHosting::GitoliteAccessor.update_projects(
      'all',
      message: 'Forced resync of all projects (active, closed, archived)...',
      force: true
    )
    RedmineGitHosting::GitoliteAccessor.resync_ssh_keys
    RedmineGitHosting::GitoliteAccessor.flush_git_cache
  end
end
