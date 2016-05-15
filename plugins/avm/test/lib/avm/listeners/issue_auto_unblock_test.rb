require 'test_helper'

module Avm
  module Listeners
    class IssueAutoUnblockTest < ActiveSupport::TestCase
      fixtures :issues, :issue_relations, :issue_statuses, :projects, :trackers, :users
      attr_reader :blocked, :blocking

      setup do
        EacBase::EventManager.delay_disabled = true
        Setting.plugin_avm['issue_status_undefined_id'] = 1
        Setting.plugin_avm['issue_status_blocked_id'] = 4
        Setting.plugin_avm['issue_status_unblocked_id'] = 2
        Setting.plugin_avm['admin_user_id'] = 1
        @blocked = issues(:issues_009)
        @blocking = issues(:issues_010)
        @blocked.status = Avm::Settings.issue_status_blocked
        @blocked.save!
        @blocked.reload
        assert @blocked.relations_to.where(issue_from: @blocking).any?
        assert_equal Avm::Settings.issue_status_blocked, @blocked.status
      end

      test 'unblock by issue relation delete' do
        r = blocked.relations_to.where(issue_from: blocking).first
        assert r
        r.destroy!
        assert_not blocked.relations_to.where(issue_from: blocking).any?

        blocked.reload
        blocked.dependencies.each do |d|
          assert d.closed?, "#{d} is not closed"
        end
        assert_equal Avm::Settings.issue_status_unblocked, blocked.status
      end

      test 'unblock by issue delete' do
        blocked = issues(:issues_009)
        blocking = issues(:issues_010)
        blocked.status = Avm::Settings.issue_status_blocked
        blocked.save!
        assert blocked.relations_to.where(issue_from: blocking).any?
        assert_equal Avm::Settings.issue_status_blocked, blocked.status
        blocking.destroy!
        blocked.reload
        blocked.dependencies.each do |d|
          assert d.closed?, "#{d} is not closed"
        end
        assert_equal Avm::Settings.issue_status_unblocked, blocked.status
      end
    end
  end
end
