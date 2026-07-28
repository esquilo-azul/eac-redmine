# frozen_string_literal: true

RSpec.describe(Issue, '#motivated?') do # rubocop:disable RSpec/SpecFilePathFormat
  fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
           :users

  before do
    IssueRelation.destroy_all
  end

  let(:blocked) { issues(:issues_009) } # rubocop:disable Naming/VariableNumber
  let(:blocker) { issues(:issues_010) } # rubocop:disable Naming/VariableNumber

  def self.fixtures_dir
    File.expand_path('motivation_spec_files', __dir__)
  end

  def self.target_source_fixtures
    EacRubyGemSupport::SourceTargetFixtures.new(fixtures_dir)
  end

  target_source_fixtures.source_target_files.each do |st|
    it "motivation #{File.basename(st.source)}" do # rubocop:disable RSpec/ExampleLength
      td = YAML.load_file(st.target)
      update_issues(YAML.load_file(st.source))

      %i[blocked blocked].each do |i|
        %i[motivated motivated_by_self motivated_by_relations].each do |m|
          expected = td[i][m]
          actual = send(i).send("#{m}?")
          expect(actual).to eq(expected), "#{i}/#{m}"
        end
      end
    end
  end

  it 'there are fixtures' do
    expect(self.class.target_source_fixtures.source_target_files).to be_any
  end

  def update_issues(data)
    update_blocked(data[:description])
    update_blocker
    update_relation(data[:blocked_by])
  end

  def update_blocked(description) # rubocop:disable Metrics/AbcSize
    blocked.init_journal(users(:users_001), '') # rubocop:disable Naming/VariableNumber
    blocked.description = description
    blocked.status_id = issue_statuses(:issue_statuses_002).id # rubocop:disable Naming/VariableNumber
    blocked.save!
    blocked.reload
    expect(blocked).not_to be_undefined, blocked.status.to_s
  end

  def update_blocker # rubocop:disable Metrics/AbcSize
    blocker.init_journal(users(:users_001), '') # rubocop:disable Naming/VariableNumber
    blocker.status_id = issue_statuses(:issue_statuses_002).id # rubocop:disable Naming/VariableNumber
    blocker.save!
    blocker.reload
    expect(blocker).not_to be_undefined, blocker.status.to_s
  end

  def update_relation(blocked_by)
    relation = blocked.relations_to.where(issue_from: blocker)
    expect(relation).to be_empty
    return unless blocked_by

    IssueRelation.create!(issue_to: blocked, issue_from: blocker,
                          type: IssueRelation::TYPE_BLOCKS)
    relation.destroy_all
    expect(relation).to be_any
  end
end
