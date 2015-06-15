# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectReplicate
    # Transforma as atualizações e-Sosti em atualizações do Redmine
    class RedmineImportThread < LoopThread      
      def run
        run_database_operation do
          updates = updates_abertos
          log(:debug, 'Updates encontrados: ' + updates.count.to_s)
          for update in updates_abertos
            update_text = "#{update.esosti_solicitacao.esosti_id}/#{update.index}"
            log(:debug, "Importando #{update_text}")
            result = EsostiRedmineImport.update_to_redmine(update)
            log(:info, "Importado #{update_text}: #{result.inspect}")
          end
        end
        sleep(SLEEP_INTERVAL)
      end
            
      def to_s
        return 'REDMINE IMPORT'
      end
      
      private
      
      def updates_abertos
        return EsostiUpdate.
          where(journal_id: nil).
          includes(:esosti_solicitacao).
          where('esosti_solicitacaos.trf1_sjap_project_id' => @esosti_project_replicate.trf1_sjap_project).
          order(:esosti_solicitacao_id, :index)
      end
    end
  end

end