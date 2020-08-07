module RedmineAvm
  class TestConfig
    def before_each
      s = ::Setting.plugin_redmine_avm.dup || {}
      s['issue_status_undefined_id'] = 1
      s['issue_status_blocked_id'] = 4
      s['issue_status_unblocked_id'] = 2
      s['admin_user_id'] = 1
      ::Setting.plugin_redmine_avm = s
      ::ListenerOption.listener_enable('Avm::Listeners::IssueMotivationCheck', false)
    end
  end
end
