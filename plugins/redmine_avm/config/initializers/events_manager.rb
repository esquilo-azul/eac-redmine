EventsManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoUndefine')
EventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUndefine')
EventsManager.add_listener(IssueRelation, :create, 'Avm::Listeners::IssueAutoUndefine')
EventsManager.add_listener(IssueRelation, :delete, 'Avm::Listeners::IssueAutoUnblock')
EventsManager.add_listener(Issue, :delete, 'Avm::Listeners::IssueAutoUnblock')
EventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoUnblock')
EventsManager.add_listener(Issue, :create, 'Avm::Listeners::IssueAutoAssign')
EventsManager.add_listener(Issue, :update, 'Avm::Listeners::IssueAutoAssign')
EventsManager.add_listener(Issue, :update,
                           'Avm::Listeners::IssueDependenciesSectionCheck')
EventsManager.add_listener(IssueRelation, :create,
                           'Avm::Listeners::IssueDependenciesSectionCheck')
[[Issue, :create], [Issue, :update], [IssueRelation, :create]].each do |v|
  EventsManager.add_listener(v.first, v.last, 'Avm::Listeners::IssueMotivationCheck')
end
