# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class EsostiProjectSync
    def initialize trf1_sjap_project
      @trf1_sjap_project = trf1_sjap_project
      @session = Trf1Sjap::EadminHttpSession.new(
          @trf1_sjap_project.eadmin_matricula,
          @trf1_sjap_project.eadmin_senha,
          @trf1_sjap_project.eadmin_banco
          )
      @login_phase = true
    end

    def run_step
      if @login_phase
        Rails.logger.info "Login e-Admin " + @trf1_sjap_project.eadmin_matricula + "/" + @trf1_sjap_project.eadmin_banco
        loginResult = @session.login
        if loginResult === true
          Rails.logger.info "Login ok"
          @login_phase = false
        else
          Rails.logger.info "Login falhou: " + loginResult.to_s
        end
      else
        begin
          Rails.logger.info "Procurado solicitações em aberto"
          caixa_atendimento = @session.caixaAtendimentoSecao
          Rails.logger.info "Solicitações encontradas: " + caixa_atendimento.solicitacoes.length.to_s
          for solicitacao in caixa_atendimento.solicitacoes do
            check_solicitacao solicitacao
          end
        rescue Exception => ex
          Rails.logger.info ex.to_s
          Rails.logger.info ex.backtrace
          @login_phase = true
        end
      end
    end

    private

    def check_solicitacao solicitacao
      Rails.logger.info "Solicitação na caixa de atendimento do e-Sosti: #{solicitacao[:numero]}"
      issue = Issue.find_by_esosti_numero(solicitacao[:numero])
      if ! issue
        Rails.logger.info "Solicitação e-Sosti nº #{solicitacao[:numero]} não existe no Redmine. Criando..."
        create_issue(solicitacao)
      end
    end

    def create_issue(solicitacao)
      issue = Issue.new
      issue.project_id = @trf1_sjap_project.project.id
      issue.subject = 'e-Sosti ' + solicitacao[:numero]
      issue.description = solicitacao.to_s
      issue.author_id = get_solicitacao_user_id(solicitacao)
      issue.tracker_id = get_tracker_id
      issue.esosti_numero = solicitacao[:numero]
      try_save(issue)
      return issue
    end

    def get_solicitacao_user_id(solicitacao)
      solicitacao_user = parse_solicitacao_user(solicitacao[:solicitante])
      user = User.find_by_login(solicitacao_user[:login])
      if ! user
        user = User.new
        user.login = solicitacao_user[:login]
        user.firstname = solicitacao_user[:firstname]
        user.lastname = solicitacao_user[:lastname]
        user.mail = solicitacao_user[:login] + '@localhost.localhost'
        try_save user
      end
      return user.id
    end

    def parse_solicitacao_user esosti_solicitante
      parts = /\s*([0-9a-zA-Z]+)\s*\-\s*(\S+(?:\s+\S+)*)\s*/.match(esosti_solicitante)
      login = parts[1].downcase
      names = parts[2].scan(/\S+/)
      firstname = names[0].capitalize
      lastname = names[1..names.size].map{|name| name.length <= 2 ? name.downcase : name.capitalize}.join(' ')
      return {:login => login, :firstname => firstname, :lastname => lastname}
    end

    def get_tracker_id
      return @trf1_sjap_project.project.trackers[0].id
    end

    def active_record_base_errors_to_string errors
      b = ''
      errors.messages.each do |field, messages|
        if b != ''
          b += ' / '
        end
        b += field.to_s + ": " + messages.to_s
      end
      return b
    end

    def try_save model_instance
      if ! model_instance.save
        raise "Falha ao tentar salvar " + model_instance.class.name + ": " + active_record_base_errors_to_string(model_instance.errors)
      end
    end
  end

end