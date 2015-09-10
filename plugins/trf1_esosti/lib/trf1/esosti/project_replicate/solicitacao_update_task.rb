# encoding: UTF-8

module Trf1
  module Esosti
    class ProjectReplicate
      # Lê os detalhes de uma solicitação
      class SolicitacaoUpdateTask < UpdateTask
        def initialize(project_replicate, esosti_solicitacao)
          @esosti_solicitacao = esosti_solicitacao
          super(project_replicate)
        end

        def run
          if @esosti_solicitacao.closed_by_update?
            run_close
          else
            run_replicate
          end
        end

        def to_s
          "SOLICITACAO(#{@esosti_solicitacao.esosti_id})"
        end

        private

        def run_close
          @esosti_solicitacao.closed = true
          Trf1Sjap::ModelUtils.save_or_raise(@esosti_solicitacao)
          log(:info, 'Monitoramento de solicitação terminado')
        end

        def run_replicate
          log(:debug, 'Buscando fonte...')
          detalhes = @project_replicate.session.solicitacao_detalhes(@esosti_solicitacao.esosti_id)
          updates = detalhes.updates
          propriedades = detalhes.propriedades
          log(:debug, 'Updates encontrados: ' + updates.count.to_s)
          log(:debug, 'Propriedades encontradas: ' + propriedades.count.to_s)
          novos = Trf1Sjap::EsostiRedmineImport.import_solicitacao_detalhes(@esosti_solicitacao, propriedades, updates)
          log((novos[0] > 0 ? :info : :debug), 'Novas propriedades: ' + novos[0].to_s)
          log((novos[1] > 0 ? :info : :debug), 'Novos updates: ' + novos[1].to_s)
        end
      end
    end
  end
end
