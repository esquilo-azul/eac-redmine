# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Lê continuamente a caixa de seção de atendimento do projeto.
    class CaixaAtendimentoSecaoThread < LoopThread
      def run
        begin
          log 'Buscando fonte...'
          caixa_atendimento = @esosti_project_replicate.session.caixaAtendimentoSecao
          log "Solicitações encontradas: " + caixa_atendimento.solicitacoes.length.to_s
          run_database_operation do
            novas = Trf1Sjap::EsostiRedmineImport.import_caixa_secao_atendimento(@esosti_project_replicate.trf1_sjap_project, caixa_atendimento.solicitacoes)
            log "Novas solicitações: " + novas.to_s
          end
          sleep(SLEEP_INTERVAL)
        rescue Trf1Sjap::EadminHttpSession::UserNotLogged => ex
          log 'Não logado. Sinalizando...'
          @esosti_project_replicate.not_logged_signal()
          Thread.stop
        end
      end

      def to_s
        return 'CAIXA'
      end
    end
  end
end