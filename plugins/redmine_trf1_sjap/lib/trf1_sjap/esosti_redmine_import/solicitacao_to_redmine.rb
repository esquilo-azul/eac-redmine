# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class SolicitacaoToRedmine
      attr_reader :result
      def initialize(esosti_solicitacao)
        @result = { issue_id: nil }
        ActiveRecord::Base.transaction do
          unless esosti_solicitacao.issue_id
            @result[:issue_id] = esosti_solicitacao.issue.id
          end
        end
      end
    end
  end
end
