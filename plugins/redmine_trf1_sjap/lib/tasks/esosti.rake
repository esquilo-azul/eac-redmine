namespace :trf1_sjap do
  namespace :esosti do
    
    task :check_solicitacoes_closing => [:environment] do
      solicitacoes = EsostiSolicitacao.where(:closed => false)
      puts "Solicitações abertas: #{solicitacoes.count}"
      for solicitacao in solicitacoes
        puts "------------------------------"
        puts "Verificando #{solicitacao.esosti_id}"
        closed_by_update = solicitacao.closed_by_update?
        puts "Fechado por update: #{closed_by_update}"
        for update in solicitacao.updates
          puts "\t#{update.fase.rotulo} => #{update.fase.is_closed}" 
        end
      end 
    end

    task :list_open_solicitacoes => [:environment] do
      solicitacoes = EsostiSolicitacao.where(:closed => false)      
      for solicitacao in solicitacoes
        puts "Verificando #{solicitacao.esosti_id} ##{solicitacao.issue_id}"
      end
      puts "------------------------------"
      puts "Total: #{solicitacoes.count}" 
    end

    task :updates_to_redmine => [:environment] do
      for trf1_sjap_project in Trf1SjapProject.all
        updates = trf1_sjap_project.esosti_updates_abertos
        puts "Updates abertos encontrados para #{trf1_sjap_project}: #{updates.count}"
        for update in updates
          puts "Importando #{update}"
          result = Trf1Sjap::EsostiRedmineImport.update_to_redmine(update)
          puts "Importado #{update}: #{result.inspect}"
        end
      end
    end

    task :reset_solicitacao_import,  [:esosti_update_id] => [:environment] do |t, args|
      ActiveRecord::Base.transaction do
        esosti_solicitacao = EsostiSolicitacao.find(args.esosti_update_id)
        esosti_solicitacao.updates.each do |update|
          update.journal_id = nil
          Trf1Sjap::ModelUtils.save_or_raise(update)
        end
        esosti_solicitacao.issue_id = nil
        Trf1Sjap::ModelUtils.save_or_raise(esosti_solicitacao)
      end
    end

  end
end
