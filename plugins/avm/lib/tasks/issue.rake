namespace :avm do
  namespace :issue do
    desc 'Verifica auto-indefinição de uma tarefa'
    task :undefine, [:issue_id] => :environment do |_t, args|
      Avm::Issue::Undefine.new(Issue.find(args.issue_id)).run
    end

    desc 'Verifica auto-indefinição de todas as tarefas indefinidas'
    task undefine_all: :environment do |_t, _args|
      Issue.where.not(status: Avm::Settings.issue_status_undefined).each do |i|
        Avm::Issue::Undefine.new(i).run
      end
    end

    desc 'Verifica auto-desbloqueio de uma tarefa'
    task unblock: :environment do |_t, _args|
      Issue.where(status: Avm::Settings.issue_status_blocked).each do |i|
        Avm::Issue::Unblock.new(i).run
      end
    end

    desc 'Verifica auto-desbloqueio de todas as tarefas'
    task unblock_all: :environment do |_t, _args|
      Issue.where(status: Avm::Settings.issue_status_blocked).each do |i|
        Avm::Issue::Unblock.new(i).run
      end
    end
  end
end
