# encoding: UTF-8
class Trf1SjapProject < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :project_id
  validates_presence_of :project_id, :eadmin_matricula, :eadmin_senha, :eadmin_banco
  def to_s
    return project.to_s
  end

  #
  #
  # Params:
  # +solicitacao+:: uma linha da caixa de entrada de seção do e-Sosti
  #
  def import_caixa_atendimento_secao_solicitacao(solicitacao)
    Rails.logger.info "Solicitação na caixa de atendimento do e-Sosti: #{solicitacao[:numero]}"
    issue = Issue.find_by_esosti_id(solicitacao[:id])
    if ! issue
      Rails.logger.info "Solicitação e-Sosti nº #{solicitacao[:numero]} não existe no Redmine. Criando..."
      create_issue(solicitacao)
    end
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
      :lastname => capitalize_name(names[1..names.size], 255)
    }
  end

  private

  def create_issue(solicitacao)
    issue = Issue.new
    issue.project_id = project.id
    issue.subject = 'e-Sosti ' + solicitacao[:numero]
    issue.description = solicitacao.to_s
    issue.author_id = get_solicitacao_user_id(solicitacao)
    issue.tracker_id = get_tracker_id
    issue.esosti_id = solicitacao[:id]
    try_save(issue)
    return issue
  end

  def get_solicitacao_user_id(solicitacao)
    solicitacao_user = Trf1SjapProject.parse_solicitacao_user(solicitacao[:solicitante])
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

  def get_tracker_id
    if project.trackers.empty?
      raise 'Projeto não possui trackers'
    end
    return project.trackers[0].id
  end

  def self.capitalize_name(names, limit)
    names.map{|name| name.length <= 2 ? UnicodeUtils.downcase(name, :pt) : UnicodeUtils.titlecase(name, :pt)}.join(' ').truncate(limit)
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
