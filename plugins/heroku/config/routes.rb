RedmineApp::Application.routes.draw do
  resources(:heroku_accounts) { as_routes }
end
