# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  mount TasksScheduler::Engine, at: '/'
end
