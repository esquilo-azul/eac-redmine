RedmineApp::Application.routes.draw do
  resources :esosti_fases
  match 'eadmin/esosti_alerta', controller: 'eadmin', action: 'esosti_alerta', via: [:get]
  match 'eadmin/esosti_alerta_data', controller: 'eadmin', action: 'esosti_alerta_data',
                                     as: 'esosti_alerta_data', via: [:post]
  match 'eadmin/settings/:project_id', to: 'eadmin#settings', via: [:get, :patch]
  match 'eadmin/eadmin_test_login/:project_id', to: 'eadmin#eadmin_test_login', via: [:get]
end
