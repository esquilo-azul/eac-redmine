RedmineApp::Application.routes.draw do
  resources :panel_issue_status_groups
  resources(:funcionarios) { as_routes }
  resources(:panel_issue_statuses) {as_routes}
  resources(:cef_id_solicitacaos) { as_routes }
  resources(:user_roles) { as_routes }
  match 'trf1_sjap/:project_id', to: 'trf1_sjap#index', via: [:get]
  match 'sjap', to: 'trf1_sjap_welcome#index', via: [:get]
end
