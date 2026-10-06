# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :redmine_avm do
  name 'Redmine\'s AVM plugin'
  author RedmineNonprojectModules::AUTHOR
  description RedmineAvm::SUMMARY
  version RedmineNonprojectModules::VERSION
  url RedmineNonprojectModules::HOMEPAGE

  settings(partial: 'settings/avm')
end
