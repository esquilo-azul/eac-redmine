# coding: utf-8

require 'redmine'

Redmine::Plugin.register :cef_ids do
  name 'Identidades digitas da Caixa Econômica Federal'
  author 'TRF1 - SJAP - SEINF'
  description 'Identidades digitas da Caixa Econômica Federal'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'
  settings default: {
    'cef_id_solicitacoes_consulta_outdated_seconds' => 60 * 60 * 24
  }, partial: 'settings/cef_ids'

  Redmine::MenuManager.map :cef_ids do |menu|
    menu.push :cef_id_solicitacaos, { controller: 'cef_id_solicitacaos', action: 'index' }, caption: :label_cef_id_solicitacaos_plural, if: proc { UserRole.user_has_role('cef_id_solicitacao_read') }
    menu.push :cef_id_solicitacaos_relatorio_gravacaos,
              { controller: 'cef_id_solicitacaos', action: 'relatorio_gravacoes' },
              caption: 'Relatório de gravações',
              if: proc { UserRole.user_has_role('cef_id_solicitacao_read') }
  end
end
