RedmineApp::Application.routes.draw do
  resources :esosti_fases
  resources(:funcionarios) { as_routes }
  resources(:cef_id_solicitacaos) { as_routes }
  match 'eadmin/esosti_alerta', :controller => 'eadmin', :action => 'esosti_alerta', :via => [:get]
  match 'eadmin/esosti_alerta_data', :controller => 'eadmin', :action => 'esosti_alerta_data', :as => 'esosti_alerta_data', :via => [:post]
  match 'trf1_sjap/:project_id', :to => 'trf1_sjap#index', :via => [:get]   
  match 'trf1_sjap/settings/:project_id', :to => 'trf1_sjap#settings', :via => [:get, :patch]
  match 'trf1_sjap/eadmin_test_login/:project_id', :to => 'trf1_sjap#eadmin_test_login', :via => [:get]
  match 'sjap', :to => 'trf1_sjap_welcome#index', :via => [:get]
end
