# coding: utf-8

require 'redmine'

require 'eac_base/patches/issue_patch'
require 'eac_base/patches/issue_relation_patch'
require 'eac_base/patches/journal_patch'
require 'eac_base/patches/time_entry_patch'
require 'eac_base/event_manager'
require 'eac_base/patches/hooks/redmine_patch'

Redmine::Plugin.register :eac_base do
  name 'Esquilo Azul Company - Base'
  author 'Eduardo Henrique Bogoni'
  description 'Base dos plugins para a Esquilo Azul Company'
  version '0.1.0'
end
