RedmineApp::Application.routes.draw do
  match 'trf1_sjap/:project_id', :to => 'trf1_sjap#index', :via => [:get]   
end
