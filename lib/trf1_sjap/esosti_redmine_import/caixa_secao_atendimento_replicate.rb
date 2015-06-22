# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class CaixaSecaoAtendimentoReplicate

      attr_reader :result
      def initialize(trf1_sjap_project, solicitacoes)
        @result = 0
        for solicitacao in solicitacoes
          if import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
            @result += 1
          end
        end
      end

      private

      def import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
        esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(solicitacao[:id])
        if !esosti_solicitacao
          esosti_solicitacao = EsostiSolicitacao.new
          esosti_solicitacao.closed = false
          esosti_solicitacao.trf1_sjap_project_id = trf1_sjap_project.id
          esosti_solicitacao.esosti_id = solicitacao[:id]
          esosti_solicitacao.esosti_numero = solicitacao[:numero]
        result = true
        else
        result = false
        end
        esosti_solicitacao.atendente = solicitacao[:atendente].strip
        ModelUtils::save_or_raise(esosti_solicitacao)
        result
      end

    end
  end
end