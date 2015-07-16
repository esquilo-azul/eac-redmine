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
          if is_project_member_or_empty(atendente_user_id)
            issue.assigned_to_id = atendente_user_id
            if !is_project_member_or_empty(atendente_anterior_user_id)
              issue.status_id = Setting.plugin_redmine_trf1_sjap['assigned_to_member_status_id']
            end
          else
            issue.status_id = Setting.plugin_redmine_trf1_sjap['assigned_to_no_member_status_id']
          end
          Trf1Sjap::ModelUtils.save_or_raise(issue)
          @result = issue.current_journal.id
          @esosti_solicitacao.atendente_anterior = @esosti_solicitacao.atendente
          Trf1Sjap::ModelUtils.save_or_raise(@esosti_solicitacao)
        end
      end

      private
      
      def is_project_member_or_empty(user_id)
        return true if user_id == nil
        Member.where(project_id: @esosti_solicitacao.trf1_sjap_project.project).all.any? do |member|
          member.user_id == user_id
        end
      end

      def atendente_user_id()
        if !defined? @atendente_user_id
          if @esosti_solicitacao.atendente == ''
            @atendente_user_id = nil
          else
            @atendente_user_id = EsostiUsuario.get_or_create(@esosti_solicitacao.atendente).to_redmine_user.id
          end
        end
        @atendente_user_id
      end
      
      def atendente_anterior_user_id()
        if !defined? @atendente_anterior_user_id
          if @esosti_solicitacao.atendente_anterior == ''
            @atendente_anterior_user_id = nil
          else
            @atendente_anterior_user_id = EsostiUsuario.get_or_create(@esosti_solicitacao.atendente_anterior).to_redmine_user.id
          end
        end
        @atendente_anterior_user_id
      end
    end

  end
end