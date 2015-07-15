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

    task :reset_solicitacao_import,  [:esosti_id] => [:environment] do |t, args|
      esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(args.esosti_id)
      if !esosti_solicitacao
        puts "Solicitação e-Sosti não encontrada com esosti_id=#{esosti_id}"
        break
      end
      ActiveRecord::Base.transaction do
        esosti_solicitacao.updates.each do |update|
          update.journal_id = nil
          Trf1Sjap::ModelUtils.save_or_raise(update)
        end
        esosti_solicitacao.issue_id = nil
        Trf1Sjap::ModelUtils.save_or_raise(esosti_solicitacao)
        puts "Solicitação resetada (esosti_id=#{esosti_solicitacao.esosti_id})"
      end
    end
    
    task :import_solicitacao_detalhes, [:project_identifier, :esosti_id] => [:environment] do |t, args|
      project = Project.find_by_identifier(args.project_identifier)
      if !project
        puts "Project not found (identifier=\"#{args.project_identifier}\")"
        next
      end
      puts "Project found: \"#{project}\""
      
      trf1_sjap_project = Trf1SjapProject.find_by_project_id(project.id)
      if !trf1_sjap_project
        puts "Trf1SjapProject not found for \"#{project}\""
        next
      end
      puts "Trf1SjapProject found"

      session = trf1_sjap_project.create_eadmin_http_session
      puts "Logging..."
      loginResult = session.login
      puts "Login result: #{loginResult}"
        
      if loginResult != true
        next
      end

      puts "Recuperando detalhes..."         
      solicitacao_detalhes = session.solicitacao_detalhes(args.esosti_id)
      puts "Detalhes recuperados"
      esosti_solicitacao = EsostiSolicitacao.get_or_create(trf1_sjap_project, args.esosti_id)      
      puts "Updates: #{solicitacao_detalhes.updates.count}" 
      puts "Propriedades: #{solicitacao_detalhes.propriedades.count}"
      puts "Novos updates: #{esosti_solicitacao.assert_updates(solicitacao_detalhes.updates)}"
      puts "Novas propriedades: #{esosti_solicitacao.assert_propriedades(solicitacao_detalhes.propriedades)}"
    end

  end
end
