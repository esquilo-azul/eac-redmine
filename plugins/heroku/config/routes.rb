RedmineApp::Application.routes.draw do
  concern :active_scaffold, ActiveScaffold::Routing::Basic.new(association: true)
  resources(:heroku_accounts, concerns: :active_scaffold)
  resources(:heroku_applications, concerns: :active_scaffold)
end
