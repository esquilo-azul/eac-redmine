RedmineApp::Application.routes.draw do
  get '/daemons', to: 'daemons#index', as: 'daemons'
  get '/daemons/:id/start', to: 'daemons#start', as: 'start_daemon'
  get '/daemons/:id/stop', to: 'daemons#stop', as: 'stop_daemon'
end
