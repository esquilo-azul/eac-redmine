# encoding: UTF-8

require 'test_helper'

class Trf1Sjap::AtendenteToRedmineTest < ActiveSupport::TestCase

      fixtures :enumerations, :esosti_solicitacaos, :esosti_solicitacao_propriedades,
        :issue_statuses, :members, :projects, :projects_trackers, :trackers, 
        :trf1_sjap_projects, :users

  def test_changes
    Setting.plugin_redmine_trf1_sjap['admin_user_id'] = 1
    Setting.plugin_redmine_trf1_sjap['assigned_to_no_member_status_id'] = 4
    Setting.plugin_redmine_trf1_sjap['assigned_to_member_status_id'] = 2
    esosti_solicitacao = EsostiSolicitacao.find(1)
    esosti_solicitacao.issue
    
    (2..4).each {|user_id| EsostiUsuario.get_or_create_from_user(User.find(user_id))}
    previous_status_id = esosti_solicitacao.issue.status_id
    esosti_solicitacao.atendente = 'JOHN SMITH'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 2, esosti_solicitacao.issue.assigned_to_id
    assert_equal previous_status_id, esosti_solicitacao.issue.status_id

    previous_status_id = esosti_solicitacao.issue.status_id
    esosti_solicitacao.atendente = 'DAVE LOPPER'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id
    assert_equal previous_status_id, esosti_solicitacao.issue.status_id

    esosti_solicitacao.atendente = 'ROBERT HILL'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id
    assert_equal 4, esosti_solicitacao.issue.status_id

    esosti_solicitacao.atendente = 'JOHN SMITH'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 2, esosti_solicitacao.issue.assigned_to_id
    assert_equal 2, esosti_solicitacao.issue.status_id

  end
end