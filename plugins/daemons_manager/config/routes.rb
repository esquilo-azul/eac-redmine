RedmineApp::Application.routes.draw do
  get '/daemons', to: 'daemons#index', as: 'daemons'
end
