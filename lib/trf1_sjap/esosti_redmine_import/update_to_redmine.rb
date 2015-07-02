# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class UpdateToRedmine

      include ActionView::Helpers::TextHelper

      attr_reader :result
      def initialize(esosti_update)
        @esosti_update = esosti_update
        @result = {:issue_id => nil, :esosti_update_id => nil}
        ActiveRecord::Base.transaction do
          if @esosti_update.fase_rotulo == SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
            @result[:issue_id] = create_issue()
          end
          @result[:esosti_update_id] = create_journal
        end
      end

      private

      def self.parse_solicitacao_descricao(descricao)
        descricao.strip.gsub(/^\+/,'').strip
      end

      def create_issue()
        if @esosti_update.esosti_solicitacao.issue_id != nil
          raise 'Solicitação já importada: ' + @esosti_update.inspect + ", " + @esosti_update.esosti_solicitacao.inspect
        end
        issue = Issue.new
        issue.project_id = @esosti_update.esosti_solicitacao.trf1_sjap_project.project_id
        issue.subject = get_issue_subject()
        issue.description = get_issue_description()
        issue.author_id = get_solicitacao_user().id
        issue.tracker_id = get_tracker_id()
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        @esosti_update.esosti_solicitacao.issue_id = issue.id
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_update.esosti_solicitacao)
        raise '@esosti_update.esosti_solicitacao.issue_id == nil' if @esosti_update.esosti_solicitacao.issue_id == nil
        @esosti_update.esosti_solicitacao.issue_id
      end

      def get_issue_subject()
        truncate(get_solicitacao_descricao(), length: Issue.columns_hash['subject'].limit)
      end

      def get_issue_description()
        '*Nº da solicitação:* ' + @esosti_update.esosti_solicitacao.esosti_numero + "\n\n" + get_solicitacao_descricao()
      end

      def get_solicitacao_descricao()
        UpdateToRedmine.parse_solicitacao_descricao(@esosti_update.item_valor(SolicitacaoDetalhes::SOLICITACAO_DESCRICAO_KEY))
      end

      def create_journal
        raise 'Update já importado' if @esosti_update.journal_id != nil
        raise 'Issue não associado' if @esosti_update.esosti_solicitacao.issue_id == nil
        issue = Issue.find(@esosti_update.esosti_solicitacao.issue_id)
        raise "Journal não é nulo: " + issue.current_journal.inspect if issue.current_journal
        previous_journal_id = issue.last_journal_id()
        issue.init_journal(get_solicitacao_user, esosti_update_to_notes())
        issue.status = @esosti_update.fase.issue_status if @esosti_update.fase.issue_status
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        raise 'Não foi criado um novo journal: ' + issue.last_journal_id().to_s if issue.last_journal_id() == previous_journal_id
        raise 'issue.last_journal_id() == nil' if issue.last_journal_id() == nil
        @esosti_update.journal_id = issue.last_journal_id()
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_update)
        raise '@esosti_update.journal_id == nil' if @esosti_update.journal_id == nil
        @esosti_update.journal_id
      end

      def esosti_update_to_notes()
        b = ''
        for item in @esosti_update.esosti_update_items
          b += "*#{item.nome}:* #{item.valor}\n"
        end
        b.strip
      end

      def get_solicitacao_user()
        EsostiUsuario.get_or_create(@esosti_update.item_valor(SolicitacaoDetalhes::AUTOR_ITEM_NOME)).to_redmine_user        
      end

      def get_tracker_id()
        default_tracker_id = Setting.plugin_redmine_trf1_sjap['tracker_id']
        if default_tracker_id != nil
          for tracker in @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers
            return default_tracker_id if tracker.id == default_tracker_id.to_i
          end
        end
        raise 'Projeto não possui trackers' if @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers.empty?
        return @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers[0].id
      end

    end
  end
end