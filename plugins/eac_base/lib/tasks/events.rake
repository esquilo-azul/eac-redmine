namespace :eac_base do
  namespace :events do
    namespace :issue_relation do
      desc 'Envia notificações da criação de um IssueRelation'
      task :create, [:issue_relation_id] => :environment do |_t, args|
        EacBase::EventManager.trigger(
          IssueRelation,
          :create,
          IssueRelation.find(args.issue_relation_id)
        )
      end
    end
    namespace :issue do
      desc 'Envia notificações da criação de um Issue'
      task :create, [:issue_id] => :environment do |_t, args|
        EacBase::EventManager.trigger(
          Issue,
          :create,
          Issue.find(args.issue_id)
        )
      end
    end
  end
end
