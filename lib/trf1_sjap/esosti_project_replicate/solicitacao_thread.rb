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
        if has_closed_update?
          run_close
        else
          run_sync
        end
      end

      def to_s
        return "SOLICITACAO(#{@esosti_solicitacao.esosti_id})"
      end

      private

      def has_closed_update?
        run_database_operation do
          @esosti_solicitacao.closed_by_update?
        end
      end

      def run_close
        run_database_operation do
          @esosti_solicitacao.closed = true
          Trf1Sjap::ModelUtils.save_or_raise(@esosti_solicitacao)
          log(:info, "Monitoramento de solicitação terminado")
        end
      end

      def run_sync
        @esosti_project_replicate.login_control.on_logged do
          begin
            log(:debug, "Buscando fonte...")
            updates = @esosti_project_replicate.session.solicitacao_detalhes(@esosti_solicitacao.esosti_id).updates()
            log(:debug, "Updates encontrados: " + updates.count.to_s)
            run_database_operation do
              novos = Trf1Sjap::EsostiRedmineImport.import_solicitacao_detalhes(@esosti_solicitacao, updates)
              log((novos >0 ? :info : :debug), "Novos updates: " + novos.to_s)
            end
            sleep_eadmin
          rescue Trf1Sjap::EadminHttpSession::UserNotLogged => ex
            log(:debug, 'Não logado. Sinalizando...')
            @esosti_project_replicate.login_control.not_logged
          end
        end
      end

    end
  end
end