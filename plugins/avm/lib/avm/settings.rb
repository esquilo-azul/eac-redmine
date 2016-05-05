module Avm
  class Settings
    class << self
      def issue_status_undefined(raise_if_empty = true)
        if Setting.plugin_avm['issue_status_undefined_id'].present?
          IssueStatus.find(Setting.plugin_avm['issue_status_undefined_id'])
        elsif raise_if_empty
          raise "Situação de tarefa indefida não configurada. Acesse /settings/plugin/avm."
        end
      end

      def admin_user(raise_if_empty = true)
        if Setting.plugin_avm['admin_user_id'].present?
          User.find(Setting.plugin_avm['admin_user_id'])
        elsif raise_if_empty
          raise "Usuário administrador não configurado. Acesse /settings/plugin/avm."
        end
      end
    end
  end
end
