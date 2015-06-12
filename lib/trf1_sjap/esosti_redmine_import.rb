# encoding: UTF-8

module Trf1Sjap  
  class EsostiRedmineImport
    # Replica no redmine os e-Sostis encontrados na caixa de atendimentos da seção do e-Sosti no e-Admin.
    def self.import_caixa_secao_atendimento(trf1_sjap_project, solicitacoes)
      novas = 0
      for solicitacao in solicitacoes
        if import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
          novas += 1
        end
      end
      return novas
    end
    # Replica no redmine os updates da página de detalhes de solicitação e-Sosti do e-Admin.
    def self.import_solicitacao_detalhes(esosti_solicitacao, updates)
      raise 'updates.count <= 0' if updates.count <= 0
      raise "updates[0][:fase] != FASE_CADASTRO_DESCRICAO (#{esosti_solicitacao.esosti_id}, \"#{updates[0][:fase]}\")" if updates[0][:fase] != SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
      index = 0
      novas = 0
      for update in updates
        if import_solicitacao_update(esosti_solicitacao, update, index)
          novas += 1
        end
        index += 1
      end
      return novas
    end

    # Transforma um update e-Sosti (Já na base de dados do Redmine) em um Issue
    # ou Comment no Redmine.
    def self.update_to_redmine(esosti_update)
      UpdateToRedmine.new(esosti_update).run()
    end

    private
    
    def self.import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
      esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(solicitacao[:id])
      if !esosti_solicitacao 
        esosti_solicitacao = EsostiSolicitacao.new
        esosti_solicitacao.closed = false
        esosti_solicitacao.trf1_sjap_project_id = trf1_sjap_project.id
        esosti_solicitacao.esosti_id = solicitacao[:id]
        esosti_solicitacao.esosti_numero = solicitacao[:numero]
        ModelUtils::save_or_raise(esosti_solicitacao)
        return true
      else
        return false
      end    
    end
    
    def self.import_solicitacao_update(esosti_solicitacao, update, index)
      esosti_update = EsostiUpdate.where(esosti_solicitacao_id: esosti_solicitacao.id, index: index).first
      if !esosti_update
        ActiveRecord::Base.transaction do
          esosti_update = EsostiUpdate.new
          esosti_update.esosti_solicitacao_id = esosti_solicitacao.id
          esosti_update.index = index
          ModelUtils.save_or_raise(esosti_update)
          update[:itens].each do |key, value|
            item = EsostiUpdateItem.new
            item.esosti_update_id = esosti_update.id
            item.nome = key
            item.valor = value
            ModelUtils.save_or_raise(item)
          end
        end
        return true
      else
        return false
      end
    end
   
    class UpdateToRedmine

      include ActionView::Helpers::TextHelper
      def initialize(esosti_update)
        @esosti_update = esosti_update
      end

      def run
        fase_descricao, fase_data = SolicitacaoDetalhes.parse_fase(@esosti_update.item_valor('Fase'))
        result = [nil, nil]
        ActiveRecord::Base.transaction do
          if fase_descricao == SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
            result[0] = create_issue()
          end
          result[1] = create_journal()
        end
        result
      end

      # Converte um identificador de usuário do e-Admin
      # em campos para o model User do Redmine.
      #
      # "AP20199 EDUARDO HENRIQUE BOGONI" => login: "ap20199", firstname: "Eduardo", lastname: "Henrique Bogoni"
      #
      #
      def self.parse_solicitacao_user(esosti_solicitante)
        parts = /\s*([0-9a-zA-Z]+)\s*\-\s*(\S+(?:\s+\S+)*)\s*/.match(esosti_solicitante)
        names = parts[2].scan(/\S+/)
        return {
          :login => parts[1].downcase,
          :firstname => capitalize_name([names[0]], 30),
          :lastname => capitalize_name(names[1..names.size], 30)
        }
      end

      def self.parse_solicitacao_descricao(descricao)
        descricao.strip.gsub(/^\+/,'').strip
      end

      private

      def create_issue()
        if @esosti_update.esosti_solicitacao.issue_id != nil
          raise 'Solicitação já importada: ' + @esosti_update.inspect + ", " + @esosti_update.esosti_solicitacao.inspect
        end
        issue = Issue.new
        issue.project_id = @esosti_update.esosti_solicitacao.trf1_sjap_project.project_id
        issue.subject = get_issue_subject()
        issue.description = get_issue_description()
        issue.author_id = get_solicitacao_user().id
        issue.tracker_id = get_tracker_id()
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        @esosti_update.esosti_solicitacao.issue_id = issue.id
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_update.esosti_solicitacao)
        raise '@esosti_update.esosti_solicitacao.issue_id == nil' if @esosti_update.esosti_solicitacao.issue_id == nil
        @esosti_update.esosti_solicitacao.issue_id
      end

      def get_issue_subject()
        truncate(get_solicitacao_descricao(), length: Issue.columns_hash['subject'].limit)
      end

      def get_issue_description()
        '*Nº da solicitação:* ' + @esosti_update.esosti_solicitacao.esosti_numero + "\n\n" + get_solicitacao_descricao()
      end

      def get_solicitacao_descricao()
        UpdateToRedmine.parse_solicitacao_descricao(@esosti_update.item_valor(SolicitacaoDetalhes::SOLICITACAO_DESCRICAO_KEY))
      end

      def create_journal()
        raise 'Update já importado' if @esosti_update.journal_id != nil
        raise 'Issue não associado' if @esosti_update.esosti_solicitacao.issue_id == nil
        issue = Issue.find(@esosti_update.esosti_solicitacao.issue_id)
        raise "Journal não é nulo: " + issue.current_journal.inspect if issue.current_journal
        previous_journal_id = issue.last_journal_id()         
        issue.init_journal(get_solicitacao_user, esosti_update_to_notes())
        Trf1Sjap::ModelUtils.save_or_raise(issue)
        raise 'Não foi criado um novo journal: ' + issue.last_journal_id().to_s if issue.last_journal_id() == previous_journal_id
        raise 'issue.last_journal_id() == nil' if issue.last_journal_id() == nil  
        @esosti_update.journal_id = issue.last_journal_id()
        Trf1Sjap::ModelUtils.save_or_raise(@esosti_update)
        raise '@esosti_update.journal_id == nil' if @esosti_update.journal_id == nil
        @esosti_update.journal_id
      end
      
      def issue
        
      end

      def esosti_update_to_notes()
        b = ''
        for item in @esosti_update.esosti_update_items
          b += "*#{item.nome}:* #{item.valor}\n"
        end
        b.strip
      end

      def get_solicitacao_user()
        solicitacao_user = UpdateToRedmine.parse_solicitacao_user(@esosti_update.item_valor(SolicitacaoDetalhes::AUTOR_ITEM_NOME))
        user = User.find_by_login(solicitacao_user[:login])
        if !user
          user = User.new
          user.login = solicitacao_user[:login]
          user.firstname = solicitacao_user[:firstname]
          user.lastname = solicitacao_user[:lastname]
          user.mail = solicitacao_user[:login] + '@localhost.localhost'
          Trf1Sjap::ModelUtils.save_or_raise user
        end
        user
      end

      def get_tracker_id()
        default_tracker_id = Setting.plugin_redmine_trf1_sjap['tracker_id']
        if default_tracker_id != nil          
          for tracker in @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers            
            return default_tracker_id if tracker.id == default_tracker_id.to_i
          end
        end
        raise 'Projeto não possui trackers' if @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers.empty?
        return @esosti_update.esosti_solicitacao.trf1_sjap_project.project.trackers[0].id
      end

      def self.capitalize_name(names, limit)
        result = names.map{|name| name.length <= 2 ? UnicodeUtils.downcase(name, :pt) : UnicodeUtils.titlecase(name, :pt)}
        while result.join(' ').strip.length > limit
          new_result = abreviate_name(result)
          if new_result == result
            raise "Nome não pôde ser abreviado: #{result.join(' ').strip}"
          end
          result = new_result
          x = result.join(' ').strip
        end
        result.join(' ').strip
      end

      def self.abreviate_name(parts)
        result = abreviate_middle(parts, true)
        if result == parts
          result = abreviate_middle(parts, false)
        end
        result
      end
      
      def self.abreviate_middle(parts, skip_first_last)
        result = []        
        passed_first = false
        abreviated = false
        parts.each_with_index  do |part, i|
          if part.length > 2
            if !abreviated && ((passed_first && i != parts.length-1) || !skip_first_last)
              result << part[0] + '.'
              abreviated = true
            else
              result << part
              passed_first = true
            end
          else
            result << part            
          end
        end
        result
      end

    end
  end
end