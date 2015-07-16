# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class SolicitacaoToRedmine

      include ActionView::Helpers::TextHelper

      attr_reader :result
      def initialize(esosti_solicitacao)
        @esosti_solicitacao = esosti_solicitacao
        @result = {:issue_id => nil}
        ActiveRecord::Base.transaction do
          @result[:issue_id] = create_issue()
        end
      end

      private

      def create_issue()
        raise 'Solicitação já importada: ' + @esosti_solicitacao.inspect if @esosti_solicitacao.issue_id != nil
        issue = Issue.new
        issue.project_id = @esosti_solicitacao.trf1_sjap_project.esosti_export_project.id
        issue.subject = get_issue_subject()
        issue.description = get_issue_description()
        issue.author_id = @esosti_solicitacao.assert_usuario.to_redmine_user.id
        issue.tracker_id = get_tracker_id()
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        @esosti_solicitacao.issue_id = issue.id
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_solicitacao)
        raise '@esosti_solicitacao.issue_id == nil' if @esosti_solicitacao.issue_id == nil
        @esosti_solicitacao.issue_id
      end

      def get_issue_subject()
        truncate(get_solicitacao_descricao(), length: 200)
      end

      def get_issue_description()
        b = "*Link*: #{eadmin_link_url}\n"
        for propriedade in @esosti_solicitacao.propriedades
          b += "*#{propriedade.nome}:* #{propriedade.valor}\n"
        end
        b.strip
      end

      def get_solicitacao_descricao()
        @esosti_solicitacao.propriedade_valor(SolicitacaoDetalhes::DESCRICAO_PROPRIEDADE_NOME)
      end

      def get_tracker_id()
        default_tracker_id = Setting.plugin_redmine_trf1_sjap['tracker_id']
        if default_tracker_id != nil
          for tracker in @esosti_solicitacao.trf1_sjap_project.project.trackers
            return default_tracker_id if tracker.id == default_tracker_id.to_i
          end
        end
        raise 'Projeto não possui trackers' if @esosti_solicitacao.trf1_sjap_project.project.trackers.empty?
        return @esosti_solicitacao.trf1_sjap_project.project.trackers[0].id
      end
      
      def eadmin_link_url
        'http://sistemas.trf1.jus.br/app/e-Admin/sosti/pesquisarsolicitacoes/formpesquisa/nSosti/' + 
          @esosti_solicitacao.propriedade_valor(EsostiSolicitacaoPropriedade::NUMERO_NOME)        
      end

    end
  end
end