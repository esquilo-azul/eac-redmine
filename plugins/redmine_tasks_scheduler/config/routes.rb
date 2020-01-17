RedmineApp::Application.routes.draw do
  mount TasksScheduler::Engine, at: '/'
end
