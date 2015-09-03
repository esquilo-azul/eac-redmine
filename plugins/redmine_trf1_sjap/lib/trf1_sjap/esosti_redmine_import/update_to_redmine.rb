# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class UpdateToRedmine
      include ActionView::Helpers::TextHelper

      attr_reader :result
      def initialize(esosti_update)
        @esosti_update = esosti_update
        @result = { issue_id: nil, esosti_update_id: nil }
        ActiveRecord::Base.transaction do
          @result[:esosti_update_id] = create_journal
        end
      end

      private

      def create_journal
        fail 'Update já importado' unless @esosti_update.journal_id.nil?
        fail 'Issue não associado' if @esosti_update.esosti_solicitacao.issue_id.nil?
        issue = Issue.find(@esosti_update.esosti_solicitacao.issue_id)
        fail 'Journal não é nulo: ' + issue.current_journal.inspect if issue.current_journal
        previous_journal_id = issue.last_journal_id
        issue.init_journal(get_solicitacao_user, esosti_update_to_notes)
        issue.status = @esosti_update.fase.issue_status if @esosti_update.fase.issue_status
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        fail 'Não foi criado um novo journal: ' + issue.last_journal_id.to_s if issue.last_journal_id == previous_journal_id
        fail 'issue.last_journal_id() == nil' if issue.last_journal_id.nil?
        @esosti_update.journal_id = issue.last_journal_id
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_update)
        fail '@esosti_update.journal_id == nil' if @esosti_update.journal_id.nil?
        @esosti_update.journal_id
      end

      def esosti_update_to_notes
        b = ''
        for item in @esosti_update.esosti_update_items
          b += "*#{item.nome}:* #{item.valor}\n"
        end
        b.strip
      end

      def get_solicitacao_user
        EsostiUsuario.get_or_create(@esosti_update.item_valor(SolicitacaoDetalhes::AUTOR_ITEM_NOME)).to_redmine_user
      end
    end
  end
end
