RedmineApp::Application.routes.draw do
  resources(:issue_status_assigns) { as_routes }
end
