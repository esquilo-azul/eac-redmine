# encoding: UTF-8

require File.expand_path('../../../../../test_helper', __FILE__)

class Trf1Sjap::AtendenteToRedmineTest < ActiveSupport::TestCase

  fixtures :projects, :trf1_sjap_projects, :esosti_solicitacaos, 
    :esosti_solicitacao_propriedades, :projects_trackers, :issue_statuses,
    :enumerations, :members, :users

  def test_changes
    Setting.plugin_redmine_trf1_sjap['admin_user_id'] = 1
    esosti_solicitacao = EsostiSolicitacao.find(1)
    esosti_solicitacao.issue
    esosti_solicitacao.atendente = 'jsmith - JOHN SMITH'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 2, esosti_solicitacao.issue.assigned_to_id

    esosti_solicitacao.atendente = 'dlopper - LOPER DAVE'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id

    esosti_solicitacao.atendente = 'dlopper - LOPER DAVE'
    Trf1Sjap::EsostiRedmineImport::import_atendente_mudanca(esosti_solicitacao)
    assert_equal 3, esosti_solicitacao.issue.assigned_to_id

  end
end