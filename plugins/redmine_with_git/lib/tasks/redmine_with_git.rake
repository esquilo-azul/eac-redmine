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
end
