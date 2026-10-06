# frozen_string_literal: true

Redmine::Plugin.by_path(__FILE__).nonprojects_menu do |menu|
  menu.push :issue_status_assigns, { controller: 'issue_status_assigns', action: 'index' },
            caption: :label_issue_status_assigns
end
