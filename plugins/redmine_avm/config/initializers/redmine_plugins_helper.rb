# frozen_string_literal: true

default_value = {
  dependencies_section_title: 'Dependencies',
  no_dependencies_section_message: "Dependencies section not found.\n" \
  "Customize this message in plugin AVM's configuration.",
  dependencies_section_missing_dependencies_message:
    "Missing dependencies found dependencies section: %{ids}.\n" + # rubocop:disable Style/FormatStringToken
    "Customize this message in plugin AVM's configuration.",
  motivation_section_title: 'Motivation',
  unmotivated_message: 'This issue is not motivated.'
}

if ::RedminePluginsHelper::Available.model?(::User)
  default_admin = ::User.where(id: 1, admin: true).first
  default_value[:admin_user_id] = default_admin.id if default_admin
end

::RedminePluginsHelper::Settings.default(:redmine_avm, default_value)
