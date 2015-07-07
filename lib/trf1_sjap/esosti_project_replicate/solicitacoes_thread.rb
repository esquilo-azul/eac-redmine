# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Mantém threads de monitoramento de solicitações e-Sosti
    class SolicitacoesThread < LoopThread
      def initialize(trf1_sjap_project)
        @solicitacoes_threads = {}
        super(trf1_sjap_project)
      end

      def run
        log :debug, 'Buscando solicitações e-Sosti abertas'
        solicitacoes_abertas = EsostiSolicitacao.where(:closed => false, :trf1_sjap_project_id => @esosti_project_replicate.trf1_sjap_project.id)
        log :debug, 'Solicitações abertas: ' + solicitacoes_abertas.count.to_s
        for solicitacao in solicitacoes_abertas
          if ! @solicitacoes_threads.has_key?(solicitacao.id)
            log :debug, "Solicitação ID=#{solicitacao.id} não possui thread. Criando"
            @solicitacoes_threads[solicitacao.id] = SolicitacaoThread.new(@esosti_project_replicate, solicitacao)
          end
        end
        sleep_long
      end

      def to_s
        return 'SOLICITACOES'
      end

    end
  end
end