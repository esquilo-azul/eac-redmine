# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :redmine_avm do
  name 'Redmine\'s AVM plugin'
  author ::RedmineNonprojectModules::AUTHOR
  description ::RedmineAvm::SUMMARY
  version ::RedmineNonprojectModules::VERSION
  url ::RedmineNonprojectModules::HOMEPAGE

  settings(partial: 'settings/avm')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :issue_status_assigns, { controller: 'issue_status_assigns', action: 'index' },
              caption: :label_issue_status_assigns
  end
end
