# encoding: UTF-8

class Trf1Sjap::Redmine::UnblockIssuesTest < ActiveSupport::TestCase
  def test_blocked_by_start_date
    issue = Issue.new
    issue.start_date = nil
    assert_equal false, Trf1Sjap::Redmine::UnblockIssues.blocked_by_start_date?(issue), 'Sem data de início'
    issue.start_date = Date.today
    assert_equal false, Trf1Sjap::Redmine::UnblockIssues.blocked_by_start_date?(issue), 'Data de início é hoje'
    issue.start_date = Date.today - 1
    assert_equal false, Trf1Sjap::Redmine::UnblockIssues.blocked_by_start_date?(issue), 'Date de início foi ontem'
    issue.start_date = Date.today + 1
    assert_equal true, Trf1Sjap::Redmine::UnblockIssues.blocked_by_start_date?(issue), 'Date de início é amanhã'
  end
end
