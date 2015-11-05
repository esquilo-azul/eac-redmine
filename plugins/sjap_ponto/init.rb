# coding: utf-8

require 'redmine'

Redmine::Plugin.register :sjap_ponto do
  name 'SJAP - Ponto'
  author 'TRF1 - SJAP - SEINF'
  description 'Gerenciador de ponto eletrônico'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'
  settings default: { 'terminais_replicate_pause' => 60 * 5 }, partial: 'settings/sjap_ponto'

  Redmine::MenuManager.map :sjap_ponto do |menu|
    menu.push :ponto_terminals, { controller: 'ponto_terminals', action: 'index' }, caption: :label_ponto_terminal_plural, if: proc { User.current.admin? }
    menu.push :ponto_terminal_entradas, { controller: 'ponto_terminal_entradas', action: 'index' }, caption: :label_ponto_terminal_entrada_plural, if: proc { User.current.admin? }
    menu.push :ponto_entradas, { controller: 'ponto_entradas', action: 'index' }, caption: :label_ponto_entrada_plural, if: proc { UserRole.user_has_role('ponto_entrada_read') }
    menu.push :ponto_cancelamentos, { controller: 'ponto_cancelamentos', action: 'index' }, caption: :label_ponto_cancelamento_plural, if: proc { UserRole.user_has_role('ponto_cancelamento_read') }
    menu.push :frequencia_relatorio, { controller: 'frequencia_relatorios', action: 'index' }, caption: :label_frequencia_relatorio_plural, if: proc { UserRole.user_has_role('frequencia_relatorio_read') }
    menu.push :ponto_carga_horaria, { controller: 'ponto_carga_horarias', action: 'index' }, caption: :label_ponto_carga_horaria_plural, if: proc { UserRole.user_has_role('ponto_carga_horaria_read') }
  end
end
