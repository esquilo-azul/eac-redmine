# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  get '/backup', to: 'backup#index', as: 'backup'
  post '/backup/import', to: 'backup#import', as: 'import_backup'
end
