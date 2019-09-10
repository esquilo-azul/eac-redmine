# frozen_string_literal: true

Redmine::MenuManager.map :redmine_with_git do |menu|
  menu.push_controller(:backup)
end
