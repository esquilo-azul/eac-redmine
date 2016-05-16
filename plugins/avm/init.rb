# coding: utf-8

require 'redmine'

require 'avm/patches/issue_patch'

Redmine::Plugin.register :avm do
  name 'Agora Vai! Methodology'
  author 'Eduardo Henrique Bogoni'
  description ''
  version '0.1.0'

  settings(default: {}, partial: 'settings/avm')

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :issue_status_assigns, { controller: 'issue_status_assigns', action: 'index' },
              caption: :label_issue_status_assigns
  end
end

Rails.configuration.to_prepare do
  EacBase::EventManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(IssueRelation, :create, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(IssueRelation, :delete, 'Avm::Listeners::IssueAutoUnblock')
  EacBase::EventManager.add_listener(Issue, :delete, 'Avm::Listeners::IssueAutoUnblock')
  EacBase::EventManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUnblock')
  EacBase::EventManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoAssign')
end
