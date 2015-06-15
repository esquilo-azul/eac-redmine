# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Lê continuamente os detalhes de uma solicitação
    class SolicitacaoThread < LoopThread
      def initialize(esosti_project_sync, esosti_solicitacao)
        @esosti_solicitacao = esosti_solicitacao
        super(esosti_project_sync)
      end

      def run
        begin
          log(:debug, "Buscando fonte...")
          updates = @esosti_project_replicate.session.solicitacao_detalhes(@esosti_solicitacao.esosti_id).updates()
          log(:debug, "Updates encontrados: " + updates.count.to_s)
          run_database_operation do
            novos = Trf1Sjap::EsostiRedmineImport.import_solicitacao_detalhes(@esosti_solicitacao, updates)
            log((novos >0 ? :info : :debug), "Novos updates: " + novos.to_s)
          end
          sleep(SLEEP_INTERVAL)
        rescue Trf1Sjap::EadminHttpSession::UserNotLogged => ex
          log(:debug, 'Não logado. Sinalizando...')
          @esosti_project_replicate.not_logged_signal()
          Thread.stop
        end
      end

      def to_s
        return "SOLICITACAO(#{@esosti_solicitacao.esosti_id})"
      end
    end
  end
end