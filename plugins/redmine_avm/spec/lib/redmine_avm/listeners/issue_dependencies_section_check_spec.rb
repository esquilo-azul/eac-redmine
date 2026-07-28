# frozen_string_literal: true

RSpec.describe(RedmineAvm::Listeners::IssueDependenciesSectionCheck) do
  fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
           :users

  let(:blocked) { issues(:issues_009) } # rubocop:disable Naming/VariableNumber
  let(:blocking) { issues(:issues_010) } # rubocop:disable Naming/VariableNumber
  let(:status) { RedmineAvm::Settings.issue_status_blocked }

  before do
    blocked.status = RedmineAvm::Settings.issue_status_blocked
    blocked.save!
    blocked.reload
    expect(blocked.relations_to.where(issue_from: blocking)).to be_any # rubocop:disable RSpec/ExpectInHook
    expect(blocked.status).to eq(status) # rubocop:disable RSpec/ExpectInHook
  end

  def assert_status(description, status)
    blocked.init_journal(users(:users_001), '') # rubocop:disable Naming/VariableNumber
    blocked.description = description
    blocked.save!
    blocked.reload
    expect(blocked.status).to eq(status)
  end

  it 'dependencies ids with no dependencies section' do
    assert_status(<<~MESSAGE,
      There is not dependencies section.
    MESSAGE
                  RedmineAvm::Settings.issue_status_undefined)
  end

  it 'dependencies ids with empty dependencies section' do # rubocop:disable RSpec/ExampleLength
    assert_status(<<~MESSAGE,
      There is a dependencies section.

      h3. Dependencies

      Here is the dependencies section
    MESSAGE
                  RedmineAvm::Settings.issue_status_undefined)
  end

  it 'dependencies ids without dependency writed' do # rubocop:disable RSpec/ExampleLength
    assert_status(<<~MESSAGE,
      There is a dependencies section.

      h3. Dependencies

      #123 - dependency one
      dependency two: #456
      other dependencies: #234 #34
    MESSAGE
                  RedmineAvm::Settings.issue_status_undefined)
  end

  it 'dependencies ids with dependency writed' do # rubocop:disable RSpec/ExampleLength
    assert_status(<<~MESSAGE,
      There is a dependencies section.

      h3. Dependencies

      #123 - dependency one
      dependency two: #456
      other dependencies: #10 #34
    MESSAGE
                  status)
  end
end
