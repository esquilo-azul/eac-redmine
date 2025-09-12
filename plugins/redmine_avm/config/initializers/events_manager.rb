# frozen_string_literal: true

RedmineEventsManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(IssueRelation, :create, 'Avm::Listeners::IssueAutoUndefine')
RedmineEventsManager.add_listener(IssueRelation, :delete, 'Avm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :delete, 'Avm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUnblock')
RedmineEventsManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoAssign')
RedmineEventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoAssign')
RedmineEventsManager.add_listener(Issue, :update,
                                  'Avm::Listeners::IssueDependenciesSectionCheck')
RedmineEventsManager.add_listener(IssueRelation, :create,
                                  'Avm::Listeners::IssueDependenciesSectionCheck')
[[Issue, :create], [Issue, :update], [IssueRelation, :create]].each do |v|
  RedmineEventsManager.add_listener(v.first, v.last, 'Avm::Listeners::IssueMotivationCheck')
end
