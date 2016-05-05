# coding: utf-8

require 'redmine'

Redmine::Plugin.register :avm do
  name 'Agora Vai! Methodology'
  author 'Eduardo Henrique Bogoni'
  description ''
  version '0.1.0'

  settings(default: {}, partial: 'settings/avm')
end
