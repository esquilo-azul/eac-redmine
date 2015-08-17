# encoding: UTF-8

require 'test_helper'

module Trf1Sjap
  module Models
    class EsostiSolicitacaoTest < ActiveSupport::TestCase

      fixtures :enumerations, :esosti_solicitacaos, :esosti_solicitacao_propriedades, 
        :issue_statuses, :projects, :projects_trackers, :trackers, :trf1_sjap_projects

      def test_issue
        esosti_solicitacao = EsostiSolicitacao.find(1)
        esosti_solicitacao.issue
      end
    end
  end
end