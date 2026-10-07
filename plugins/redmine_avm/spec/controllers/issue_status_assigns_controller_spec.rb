# frozen_string_literal: true

RSpec.describe IssueStatusAssignsController, type: :feature do
  fixtures :issue_statuses

  let!(:issue_field) do # rubocop:disable RSpec/LetSetup
    IssueCustomField.create!(id: 1000, name: 'Issue field', field_format: 'user')
  end

  include_context 'with logged user', 'admin' do
    include_context 'active_scaffold_controller',
                    index_path: '/issue_status_assigns',
                    valid_create_data: { issue_status: 1, issue_field: 1000 },
                    valid_update_data: { issue_status: 2 }
  end
end
