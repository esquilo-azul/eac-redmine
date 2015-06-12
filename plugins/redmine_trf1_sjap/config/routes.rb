RedmineApp::Application.routes.draw do
  resources :esosti_fases
  match 'trf1_sjap/:project_id', :to => 'trf1_sjap#index', :via => [:get]   
  match 'trf1_sjap/settings/:project_id', :to => 'trf1_sjap#settings', :via => [:get, :put, :post]
  match 'trf1_sjap/eadmin_test_login/:project_id', :to => 'trf1_sjap#eadmin_test_login', :via => [:get]
end
