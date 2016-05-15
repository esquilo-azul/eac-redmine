# coding: utf-8

require 'redmine'

require 'avm/patches/issue_patch'

Redmine::Plugin.register :avm do
  name 'Agora Vai! Methodology'
  author 'Eduardo Henrique Bogoni'
  description ''
  version '0.1.0'

  settings(default: {}, partial: 'settings/avm')
end

Rails.configuration.to_prepare do
  EacBase::EventManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(IssueRelation, :create, 'Avm::Listeners::IssueAutoUndefine')
  EacBase::EventManager.add_listener(IssueRelation, :delete, 'Avm::Listeners::IssueAutoUnblock')
  EacBase::EventManager.add_listener(Issue, :delete, 'Avm::Listeners::IssueAutoUnblock')
end
