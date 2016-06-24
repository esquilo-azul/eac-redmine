require_relative '../../../test_helper'

module Avm
  module Listeners
    class IssueAutoUnblockTest < ActiveSupport::TestCase
      fixtures :issues, :issue_relations, :issue_statuses, :projects, :trackers, :users
      attr_reader :blocked, :blocking

      setup do
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

      test 'unblock by issue blocking closed' do
        blocking.init_journal(Avm::Settings.admin_user, '')
        blocking.status = issue_statuses(:issue_statuses_005)
        blocking.save!
        blocked.reload
        blocked.dependencies.each { |d| assert d.closed?, "#{d} is not closed" }
        assert_equal Avm::Settings.issue_status_unblocked, blocked.status
      end

      test 'unblock by issue blocking' do
        test_unblock_by_issue_blocking_closed
        blocked.init_journal(Avm::Settings.admin_user, '')
        blocked.status = Avm::Settings.issue_status_blocked
        blocked.save!
        blocked.reload
        assert_equal Avm::Settings.issue_status_unblocked, blocked.status
      end
    end
  end
end
