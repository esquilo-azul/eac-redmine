# frozen_string_literal: true

RedmineEventsManager.add_listener(Issue, :create, 'RedmineAvm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(Issue, :update, 'RedmineAvm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(IssueRelation, :create, 'RedmineAvm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(IssueRelation, :delete, 'RedmineAvm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :delete, 'RedmineAvm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :update, 'RedmineAvm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :create, 'RedmineAvm::Listeners::IssueAutoAssign')
RedmineEventsManager.add_listener(Issue, :update, 'RedmineAvm::Listeners::IssueAutoAssign')
RedmineEventsManager.add_listener(Issue, :update,
                                  'RedmineAvm::Listeners::IssueDependenciesSectionCheck')
RedmineEventsManager.add_listener(IssueRelation, :create,
                                  'RedmineAvm::Listeners::IssueDependenciesSectionCheck')
[[Issue, :create], [Issue, :update], [IssueRelation, :create]].each do |v|
  RedmineEventsManager.add_listener(v.first, v.last, 'RedmineAvm::Listeners::IssueMotivationCheck')
end
