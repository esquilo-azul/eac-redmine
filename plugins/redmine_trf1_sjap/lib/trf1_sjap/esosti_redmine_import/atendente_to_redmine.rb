# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport

    
    class AtendenteToRedmine
      
      attr_reader :result
      
      def initialize(esosti_solicitacao)
        @esosti_solicitacao = esosti_solicitacao
        @cache = {}
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
        user_id_by_esosti_usuario_nome(__method__, @esosti_solicitacao.atendente)
      end
      
      def atendente_anterior_user_id()
        user_id_by_esosti_usuario_nome(__method__, @esosti_solicitacao.atendente_anterior)
      end

      def user_id_by_esosti_usuario_nome(cache_key, esosti_usuario_nome)
        if !@cache.has_key?(cache_key)
          if esosti_usuario_nome == ''
            @cache[cache_key] = nil
          else
            esosti_usuario = EsostiUsuario.find_by_nome(esosti_usuario_nome)
            raise "Usuário e-Sosti não encontrado com o nome \"#{esosti_usuario_nome}\"" if !esosti_usuario
            @cache[cache_key] = esosti_usuario.to_redmine_user.id
          end
        end
        @cache[cache_key]
      end
    end

  end
end