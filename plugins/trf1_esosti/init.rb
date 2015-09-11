# coding: utf-8

require 'redmine'

Redmine::Plugin.register :trf1_esosti do
  name 'TRF1 - e-Sosti'
  author 'TRF1 - SJAP - SEINF'
  description 'Replicação do e-Sosti'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'
  settings default: {
    'eadmin_request_limit' => 4,
    'esosti_replicate_threads_limit' => 8
  }, partial: 'settings/trf1_esosti'
  project_module :redmine_trf1_sjap do
    permission :manage_esosti, trf1_sjap: [:settings, :eadmin_test_login]
  end

  Redmine::MenuManager.map :trf1_sjap_module_menu do |menu|
    menu.push :settings, { controller: 'trf1_sjap', action: 'settings' }, caption: 'Configurações', permission: :manage_esosti
  end
end
