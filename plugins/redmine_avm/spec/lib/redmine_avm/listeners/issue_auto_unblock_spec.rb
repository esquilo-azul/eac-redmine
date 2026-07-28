# frozen_string_literal: true

RSpec.describe(RedmineAvm::Listeners::IssueAutoUnblock) do
  fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
           :users

  let(:blocked) { issues(:issues_009) } # rubocop:disable Naming/VariableNumber
  let(:blocking) { issues(:issues_010) } # rubocop:disable Naming/VariableNumber

  before do
    blocked.status = RedmineAvm::Settings.issue_status_blocked
    blocked.description += "\nh3. Dependencies\n\n" + # rubocop:disable Style/StringConcatenation
                           blocked.dependencies.map { |d| "##{d.id}" }.join(', ')
    blocked.save!
    blocked.reload
    expect(blocked.relations_to.where(issue_from: blocking)).to be_any # rubocop:disable RSpec/ExpectInHook
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_blocked) # rubocop:disable RSpec/ExpectInHook
  end

  def assert_dependencies_closed(issue)
    issue.dependencies.each do |d| # rubocop:disable RSpec/IteratedExpectation
      expect(d).to be_closed, "#{d} is not closed"
    end
  end

  def unblock_by_issue_blocking_closed # rubocop:disable Metrics/AbcSize
    blocking.init_journal(RedmineAvm::Settings.admin_user, '')
    blocking.status = issue_statuses(:issue_statuses_005) # rubocop:disable Naming/VariableNumber
    blocking.save!
    blocked.reload
    assert_dependencies_closed(blocked)
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_unblocked)
  end

  it 'unblock by issue relation delete' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    r = blocked.relations_to.where(issue_from: blocking).first
    expect(r).to be_present
    r.destroy!
    expect(blocked.relations_to.where(issue_from: blocking)).not_to be_any

    blocked.reload
    assert_dependencies_closed(blocked)
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_unblocked)
  end

  it 'unblock by issue delete' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    blocked = issues(:issues_009) # rubocop:disable Naming/VariableNumber
    blocking = issues(:issues_010) # rubocop:disable Naming/VariableNumber
    blocked.status = RedmineAvm::Settings.issue_status_blocked
    blocked.save!
    expect(blocked.relations_to.where(issue_from: blocking)).to be_any
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_blocked)
    blocking.destroy!
    blocked.reload
    assert_dependencies_closed(blocked)
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_unblocked)
  end

  it 'unblock by issue blocking closed' do # rubocop:disable RSpec/NoExpectationExample
    unblock_by_issue_blocking_closed
  end

  it 'unblock by issue blocking' do # rubocop:disable RSpec/ExampleLength
    unblock_by_issue_blocking_closed
    blocked.init_journal(RedmineAvm::Settings.admin_user, '')
    blocked.status = RedmineAvm::Settings.issue_status_blocked
    blocked.save!
    blocked.reload
    expect(blocked.status).to eq(RedmineAvm::Settings.issue_status_unblocked)
  end
end
