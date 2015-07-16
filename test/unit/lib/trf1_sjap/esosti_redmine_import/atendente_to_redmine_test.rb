# encoding: UTF-8

require File.expand_path('../../../../../test_helper', __FILE__)

class Trf1Sjap::AtendenteToRedmineTest < ActiveSupport::TestCase

      fixtures :enumerations, :esosti_solicitacaos, :esosti_solicitacao_propriedades,
        :issue_statuses, :members, :projects, :projects_trackers, :trackers, 
        :trf1_sjap_projects

  def test_changes
    Setting.plugin_redmine_trf1_sjap['admin_user_id'] = 1
    Setting.plugin_redmine_trf1_sjap['assigned_to_no_member_status_id'] = 4
    Setting.plugin_redmine_trf1_sjap['assigned_to_member_status_id'] = 2
    esosti_solicitacao = EsostiSolicitacao.find(1)
    esosti_solicitacao.issue
    
    previous_status_id = esosti_solicitacao.issue.status_id
    esosti_solicitacao.atendente = 'jsmith - JOHN SMITH'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 2, esosti_solicitacao.issue.assigned_to_id
    assert_equal previous_status_id, esosti_solicitacao.issue.status_id

    previous_status_id = esosti_solicitacao.issue.status_id
    esosti_solicitacao.atendente = 'dlopper - LOPER DAVE'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id
    assert_equal previous_status_id, esosti_solicitacao.issue.status_id

    esosti_solicitacao.atendente = 'rhill - HILL ROBERT'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id
    assert_equal 4, esosti_solicitacao.issue.status_id

    esosti_solicitacao.atendente = 'jsmith - JOHN SMITH'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 2, esosti_solicitacao.issue.assigned_to_id
    assert_equal 2, esosti_solicitacao.issue.status_id

  end
end