# coding: utf-8

require 'redmine'

Redmine::Plugin.register :daemons_manager do
  name 'Daemons Manager'
  author 'TRF1 - SJAP - SEINF'
  description 'Gerenciador de daemons'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'
  settings default: {}, partial: 'settings/daemons_manager'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :daemons, { controller: 'daemons', action: 'index' }, caption: :label_daemons
  end
end
