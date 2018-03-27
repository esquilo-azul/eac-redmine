module Avm
  class Settings
    class << self
      def issue_status_undefined(raise_if_empty = true)
        issue_status('issue_status_undefined_id', 'indefida', raise_if_empty)
      end

      def issue_status_blocked(raise_if_empty = true)
        issue_status('issue_status_blocked_id', 'bloqueada', raise_if_empty)
      end

      def issue_status_unblocked(raise_if_empty = true)
        issue_status('issue_status_unblocked_id', 'desbloqueada', raise_if_empty)
      end

      def admin_user(raise_if_empty = true)
        if Setting.plugin_avm['admin_user_id'].present?
          User.find(Setting.plugin_avm['admin_user_id'])
        elsif raise_if_empty
          raise 'Usuário administrador não configurado. Acesse /settings/plugin/avm.'
        end
      end

      def dependencies_section_title
        required_text(__method__)
      end

      def no_dependencies_section_message
        required_text(__method__)
      end

      def dependencies_section_missing_dependencies_message
        required_text(__method__)
      end

      def motivation_section_title
        required_text(__method__)
      end

      private

      def issue_status(key, message, raise_if_empty)
        if Setting.plugin_avm[key].present?
          IssueStatus.find(Setting.plugin_avm[key])
        elsif raise_if_empty
          raise "Situação de tarefa #{message} não configurada. Acesse /settings/plugin/avm."
        end
      end

      def required_text(key)
        v = Setting.plugin_avm[key]
        return v if v.present?
        raise "Setting.plugin_avm[#{key}] is empty"
      end
    end
  end
end
