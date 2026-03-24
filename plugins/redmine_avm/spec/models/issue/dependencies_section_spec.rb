# frozen_string_literal: true

RSpec.describe(Issue, '#dependencies_section') do
  include_examples 'source_target_fixtures', __FILE__

  fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
           :users

  def source_data(file)
    issue = issue_with_description(file.to_pathname.read)
    {
      dependencies_section: issue.dependencies_section,
      dependencies_section_dependencies: issue.dependencies_section_dependencies.sort
    }
  end

  def issue_with_description(description)
    issue = issues(:issues_009) # rubocop:disable Naming/VariableNumber
    issue.init_journal(users(:users_001), '') # rubocop:disable Naming/VariableNumber
    issue.description = description
    issue.save!
    issue.reload
    blocking = issues(:issues_010) # rubocop:disable Naming/VariableNumber
    expect(issue.relations_to.where(issue_from: blocking)).to be_any
    issue
  end
end
