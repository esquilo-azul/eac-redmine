# encoding: UTF-8

module Trf1
  module Esosti
    class ProjectReplicate
      # Lê a caixa de seção de atendimento do projeto.
      class CaixaAtendimentoUpdateTask < UpdateTask
        def run
          log :debug, 'Buscando fonte...'
          caixa_atendimento = @project_replicate.session.caixaAtendimentoSecao
          log :debug, 'Solicitações encontradas: ' + caixa_atendimento.solicitacoes.length.to_s
          novas = Trf1Sjap::EsostiRedmineImport.import_caixa_secao_atendimento(@project_replicate.trf1_sjap_project, caixa_atendimento.solicitacoes)
          log((novas > 0 ? :info : :debug), 'Novas solicitações: ' + novas.to_s)
        end

        def to_s
          'CAIXA'
        end
      end
    end
  end
end
