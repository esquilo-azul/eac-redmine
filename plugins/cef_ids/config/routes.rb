RedmineApp::Application.routes.draw do
  resources(:cef_id_solicitacaos) do
    as_routes
    collection do
      get 'relatorio_gravacoes'
    end
  end
end
