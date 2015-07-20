namespace :trf1_sjap do
  namespace :redmine do

    task :unblock_issues => [:environment] do
      Trf1Sjap::Redmine::UnblockIssues.check_all
    end

  end
end
