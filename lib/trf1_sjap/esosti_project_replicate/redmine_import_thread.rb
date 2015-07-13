# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectReplicate
    # Transforma as atualizações e-Sosti em atualizações do Redmine
    class RedmineImportThread < LoopThread      
      def run
        run_database_operation do
          solicitacoes = atendente_mudancas
          log(:debug, 'Mudanças de atendentes encontradas: ' + solicitacoes.count.to_s)
          for solicitacao in solicitacoes
            solicitacao_text = "#{solicitacao.esosti_id} \"#{solicitacao.atendente_anterior}\" => \"#{solicitacao.atendente}\""
            log(:debug, "Importando mudança de atendentes #{solicitacao_text}")
            result = EsostiRedmineImport.import_atendente_mudanca(solicitacao)
            log(:info, "Importada mudança de atendente #{solicitacao_text} => journal_id: #{result.inspect}")
          end          
        end
        run_database_operation do
          updates = @esosti_project_replicate.trf1_sjap_project.esosti_updates_abertos
          log(:debug, 'Updates encontrados: ' + updates.count.to_s)
          for update in updates
            update_text = "#{update.esosti_solicitacao.esosti_id}/#{update.index}"
            log(:debug, "Importando #{update_text}")
            result = EsostiRedmineImport.update_to_redmine(update)
            log(:info, "Importado #{update_text}: #{result.inspect}")
          end
        end
        sleep_long
      end
            
      def to_s
        return 'REDMINE IMPORT'
      end
      
      private
      
      def atendente_mudancas
        return EsostiSolicitacao.where('atendente <> atendente_anterior and issue_id is not null')
      end
    end
  end

end