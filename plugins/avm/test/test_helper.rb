require 'test_helper'

module ActiveSupport
  class TestCase
    setup do
      EacBase::EventManager.delay_disabled = true
      Setting.plugin_avm['issue_status_undefined_id'] = 1
      Setting.plugin_avm['issue_status_blocked_id'] = 4
      Setting.plugin_avm['issue_status_unblocked_id'] = 2
      Setting.plugin_avm['admin_user_id'] = 1
    end
  end
end
