# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport

    
    class AtendenteToRedmine
      
      attr_reader :result
      
      def initialize(esosti_solicitacao)
        ActiveRecord::Base.transaction do
          issue = Issue.find(esosti_solicitacao.issue_id)
          issue.init_journal(EsostiRedmineImport.get_admin_user(), nil)
          issue.assigned_to_id = assigned_id(esosti_solicitacao)
          Trf1Sjap::ModelUtils.save_or_raise(issue)
          @result = issue.current_journal.id
          esosti_solicitacao.atendente_anterior = esosti_solicitacao.atendente
          Trf1Sjap::ModelUtils.save_or_raise(esosti_solicitacao)
        end
      end

      private

      def assigned_id(esosti_solicitacao)
        if esosti_solicitacao.atendente == ''
          nil
        else
          EsostiUsuario.find_by_nome(esosti_solicitacao.atendente).to_redmine_user.id
        end        
      end
    end

  end
end