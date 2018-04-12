module Avm
  module Patches
    module TestCasePatch
      def self.included(base)
        base.setup do
          s = ::Setting.plugin_avm.dup || {}
          s['issue_status_undefined_id'] = 1
          s['issue_status_blocked_id'] = 4
          s['issue_status_unblocked_id'] = 2
          s['admin_user_id'] = 1
          ::Setting.plugin_avm = s
          ::ListenerOption.listener_enable('Avm::Listeners::IssueMotivationCheck', false)
        end
      end
    end
  end
end

if Rails.env.test?
  require Rails.root.join('test', 'test_helper.rb')
  unless ::ActiveSupport::TestCase.included_modules.include? Avm::Patches::TestCasePatch
    ::ActiveSupport::TestCase.send(:include, Avm::Patches::TestCasePatch)
  end
end
