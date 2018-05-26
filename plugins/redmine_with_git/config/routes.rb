RedmineApp::Application.routes.draw do
  get '/redmine_with_git', to: 'redmine_with_git#index', as: 'redmine_with_git'
  get '/redmine_with_git/export', to: 'redmine_with_git#export', as: 'export_redmine_with_git'
  post '/redmine_with_git/import', to: 'redmine_with_git#import', as: 'import_redmine_with_git'
end
