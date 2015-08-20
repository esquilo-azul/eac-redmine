RedmineApp::Application.routes.draw do
  resources(:ponto_terminal_entradas) { as_routes }
  resources(:ponto_terminals) { as_routes }
end
