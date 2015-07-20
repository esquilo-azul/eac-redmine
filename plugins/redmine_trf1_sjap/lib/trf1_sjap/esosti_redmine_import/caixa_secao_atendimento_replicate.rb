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
          esosti_solicitacao = EsostiSolicitacao.get_or_create(trf1_sjap_project, solicitacao[:id])
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