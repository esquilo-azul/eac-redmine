require 'thread/pool'

module Trf1
  module Esosti
    class SolicitacoesImport
      def self.run_all
        run_solicitacaos_sem_issue
        run_atendente_mudancas
        run_updates_abertos
      end

      private

      def self.run_solicitacaos_sem_issue
        solicitacoes = esosti_solicitacaos_sem_issue
        Rails.logger.debug("Solicitações sem issue: #{solicitacoes.count}")
        solicitacoes.each do |solicitacao|
          Rails.logger.debug("Criando issue para #{solicitacao}")
          result = Trf1Sjap::EsostiRedmineImport.solicitacao_to_redmine(solicitacao)
          Rails.logger.info("Importado #{solicitacao}: #{result.inspect}")
        end
      end

      def self.run_atendente_mudancas
        solicitacoes = atendente_mudancas
        Rails.logger.debug('Mudanças de atendentes encontradas: ' + solicitacoes.count.to_s)
        solicitacoes.each do |solicitacao|
          solicitacao_text = "#{solicitacao.esosti_id} \"#{solicitacao.atendente_anterior}\" => \"#{solicitacao.atendente}\""
          Rails.logger.debug("Importando mudança de atendentes #{solicitacao_text}")
          result = Trf1Sjap::EsostiRedmineImport.import_atendente_mudanca(solicitacao)
          Rails.logger.info("Importada mudança de atendente #{solicitacao_text} => journal_id: #{result.inspect}")
        end
      end

      def self.run_updates_abertos
        updates = esosti_updates_abertos
        Rails.logger.debug('Updates encontrados: ' + updates.count.to_s)
        for update in updates
          update_text = "#{update.esosti_solicitacao.esosti_id}/#{update.index}"
          Rails.logger.debug("Importando #{update_text}")
          result = Trf1Sjap::EsostiRedmineImport.update_to_redmine(update)
          Rails.logger.info("Importado #{update_text}: #{result.inspect}")
        end
      end

      def self.atendente_mudancas
        EsostiSolicitacao.where('atendente <> atendente_anterior and issue_id is not null')
      end

      def self.esosti_solicitacaos_sem_issue
        EsostiSolicitacao
          .where(issue_id: nil)
          .where('id in (select distinct(esosti_solicitacao_id) from esosti_solicitacao_propriedades)')
          .order('id')
      end

      def self.esosti_updates_abertos
        EsostiUpdate
          .where(journal_id: nil)
          .order(:esosti_solicitacao_id, :index)
      end
    end
  end
end
