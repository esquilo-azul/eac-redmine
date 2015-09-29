RedmineApp::Application.routes.draw do  
  resources(:cef_id_solicitacaos) { as_routes }
end
