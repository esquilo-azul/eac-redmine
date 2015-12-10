RedmineApp::Application.routes.draw do
  resources(:ponto_cancelamentos) { as_routes }
  resources(:ponto_carga_horarias, only: %w(index new create)) do
    member do
      get 'cancelamento'
      post 'cancelamento_post'
    end
  end
  resources(:ponto_entrada_manual, only: [:new, :create])
  resources(:ponto_entradas) do
    as_routes
    member do
      get 'cancela_input'
      post 'cancela'
    end
  end
  resources(:ponto_terminal_entradas) { as_routes }
  resources(:ponto_terminals) { as_routes }
  match 'frequencia_relatorios', to: 'frequencia_relatorios#index', via: [:get, :post]
end
