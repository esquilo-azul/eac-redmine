# coding: utf-8

require 'redmine'

Redmine::Plugin.register :redmine_trf1_sjap do
  name 'TRF1 - SJAP'
  author 'TRF1 - SJAP - SEINF'
  description 'Customizações para a SJAP'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'
  settings default: {
    'unblock_message' => 'Esta tarefa foi automaticamente desbloqueada.'
  }, partial: 'settings/redmine_trf1_sjap'
  project_module :redmine_trf1_sjap do
    permission :manage_trf1_sjap, trf1_sjap: [:index]
  end
  menu :project_menu, :redmine_trf1_sjap, { controller: 'trf1_sjap', action: 'index' }, caption: :label_trf1_sjap, after: :files, param: :project_id

  Redmine::MenuManager.map :redmine_trf1_sjap do |menu|
    menu.push :main, { controller: 'trf1_sjap_welcome', action: 'index' }, caption: 'Página inicial'
    menu.push :funcionarios, { controller: 'funcionarios', action: 'index' }, caption: :label_funcionario_plural, if: proc { User.current.admin? }
    menu.push :user_roles, { controller: 'user_roles', action: 'index' }, caption: :label_user_role_plural, if: proc { User.current.admin? }
    menu.push :panel_issue_status_groups, { controller: 'panel_issue_status_groups', action: 'index' },
              caption: :label_panel_issue_status_groups, if: proc { User.current.admin? }
  end

  Redmine::MenuManager.map :trf1_sjap_module_menu do |menu|
    menu.push :main, { controller: 'trf1_sjap', action: 'index' }, caption: 'Início', permission: :manage_trf1_sjap
  end

  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :trf1_sjap, { controller: 'trf1_sjap_welcome', action: 'index' }, caption: 'SJAP'
  end
end
