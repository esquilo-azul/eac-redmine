# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  get '/backup', to: 'backup#index', as: 'backup'
end
