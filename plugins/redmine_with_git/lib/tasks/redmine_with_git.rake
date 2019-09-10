# frozen_string_literal: true

namespace :redmine_with_git do
  %w[database files git all].each do |a|
    namespace :dump do
      desc <<~DESCRIPTION
        Dump backup file for \"#{a}\" resource(s).

        Arguments:
        * <path>: path to the dump.
        * [overwrite]: 1: denied, 2: allowed, 3: rotate (Default: 1).
        * [space_limit]: limits the used space by all rotated files.
      DESCRIPTION
      task a, %i[path overwrite space_limit] => :environment do |_t, args|
        ::RedmineWithGit::Dump.const_get(a.camelize).new(args.path, overwrite: args.overwrite,
                                                                    space_limit: args.space_limit)
      end
    end
    namespace :load do
      desc "Load backup file for \"#{a}\" resource(s)"
      task a, [:path] => :environment do |_t, args|
        ::RedmineWithGit::Load.const_get(a.camelize).new(args.path)
      end
    end
  end

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
