# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  concern :active_scaffold, ActiveScaffold::Routing::Basic.new(association: true)
  resources(:issue_status_assigns, concerns: :active_scaffold)
end
