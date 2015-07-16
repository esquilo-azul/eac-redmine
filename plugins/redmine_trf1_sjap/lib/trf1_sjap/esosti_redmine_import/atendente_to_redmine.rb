# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport

    
    class AtendenteToRedmine
      
      attr_reader :result
      
      def initialize(esosti_solicitacao)
        @esosti_solicitacao = esosti_solicitacao
        ActiveRecord::Base.transaction do
          issue = Issue.find(@esosti_solicitacao.issue_id)
          issue.init_journal(EsostiRedmineImport.get_admin_user(), nil)
          issue.assigned_to_id = assigned_id()
          Trf1Sjap::ModelUtils.save_or_raise(issue)
          @result = issue.current_journal.id
          @esosti_solicitacao.atendente_anterior = @esosti_solicitacao.atendente
          Trf1Sjap::ModelUtils.save_or_raise(@esosti_solicitacao)
        end
      end

      private

      def assigned_id()
        if !defined? @atendente_user_id
          if @esosti_solicitacao.atendente == ''
            @atendente_user_id = nil
          else
            @atendente_user_id = EsostiUsuario.get_or_create(@esosti_solicitacao.atendente).to_redmine_user.id
          end
        end
        @atendente_user_id
      end
    end

  end
end