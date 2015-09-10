class EsostiSolicitacao < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  unloadable
  validates_uniqueness_of :esosti_id
  validates_uniqueness_of :issue_id, allow_nil: true
  validates_presence_of :esosti_id, :trf1_sjap_project_id
  validates :closed, exclusion: { in: [nil] }
  belongs_to :trf1_sjap_project
  belongs_to :issue

  def closed_by_update?
    for update in updates
      return true if update.fase.is_closed
    end
    false
  end

  def updates
    EsostiUpdate.where(esosti_solicitacao_id: id).order('index asc')
  end

  def propriedades
    EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: id)
  end

  def propriedade_valor(propriedade_nome)
    propriedade = EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: id, nome: propriedade_nome).first
    if propriedade
      return propriedade.valor
    else
      fail "Propriedade não encontrada (esosti_solicitacao_id: #{id}, esosti_id: #{esosti_id}, nome: #{propriedade_nome}, propriedades: #{propriedades.inspect}"
    end
  end

  def has_propriedade(propriedade_nome)
    EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: id, nome: propriedade_nome).count > 0
  end

  def self.get_or_create(trf1_sjap_project, esosti_id)
    esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(esosti_id)
    unless esosti_solicitacao
      esosti_solicitacao = EsostiSolicitacao.new
      esosti_solicitacao.closed = false
      esosti_solicitacao.trf1_sjap_project_id = trf1_sjap_project.id
      esosti_solicitacao.esosti_id = esosti_id
      Trf1Sjap::ModelUtils.save_or_raise(esosti_solicitacao)
    end
    esosti_solicitacao
  end

  def issue
    if issue_id
      Issue.find(issue_id)
    else
      new_issue = Issue.new
      new_issue.project_id = trf1_sjap_project.esosti_export_project.id
      new_issue.subject = get_issue_subject
      new_issue.description = get_issue_description
      new_issue.author_id = assert_usuario.to_redmine_user.id
      new_issue.tracker_id = get_tracker_id
      ActiveRecord::Base.transaction do
        Trf1Sjap::ModelUtils.save_or_raise(new_issue)
        self.issue_id = new_issue.id
        Trf1Sjap::ModelUtils.save_or_raise(self)
      end
      fail 'self.issue_id == nil' if issue_id.nil?
      new_issue
    end
  end

  def assert_usuario
    if has_propriedade(EsostiSolicitacaoPropriedade::POR_ORDEM_NOME)
      usuario_rotulo = propriedade_valor(EsostiSolicitacaoPropriedade::POR_ORDEM_NOME)
    else
      usuario_rotulo = "#{propriedade_valor(EsostiSolicitacaoPropriedade::MATRICULA_NOME)} - #{propriedade_valor(EsostiSolicitacaoPropriedade::NOME_SOLICITANTE_NOME)}"
    end
    EsostiUsuario.get_or_create(usuario_rotulo)
  end

  def assert_updates(raw_updates)
    novos = 0
    index = 0
    for raw_update in raw_updates
      novos += 1 if assert_update(index, raw_update[:itens])
      index += 1
    end
    novos
  end

  def assert_update(index, itens)
    esosti_update = EsostiUpdate.where(esosti_solicitacao_id: id, index: index).first
    if !esosti_update
      ActiveRecord::Base.transaction do
        esosti_update = EsostiUpdate.new
        esosti_update.esosti_solicitacao_id = id
        esosti_update.index = index
        Trf1Sjap::ModelUtils.save_or_raise(esosti_update)
        itens.each do |key, value|
          item = EsostiUpdateItem.new
          item.esosti_update_id = esosti_update.id
          item.nome = key
          item.valor = value
          Trf1Sjap::ModelUtils.save_or_raise(item)
        end
      end
      true
    else
      false
    end
  end

  def assert_propriedades(raw_propriedades)
    novos = 0
    raw_propriedades.each do |nome, valor|
      novos += 1 if assert_propriedade(nome, valor)
    end
    novos
  end

  def assert_propriedade(nome, valor)
    propriedade = EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: id, nome: nome).first
    if !propriedade
      ActiveRecord::Base.transaction do
        propriedade = EsostiSolicitacaoPropriedade.new
        propriedade.esosti_solicitacao_id = id
        propriedade.nome = nome
        propriedade.valor = valor
        Trf1Sjap::ModelUtils.save_or_raise(propriedade)
      end
      true
    else
      false
    end
  end

  private

  def get_issue_subject
    truncate(propriedade_valor(EsostiSolicitacaoPropriedade::DESCRICAO_NOME), length: 200)
  end

  def get_issue_description
    b = "*Link*: #{eadmin_link_url}\n"
    for propriedade in propriedades
      b += "*#{propriedade.nome}:* #{propriedade.valor}\n"
    end
    b.strip
  end

  def eadmin_link_url
    'http://sistemas.trf1.jus.br/app/e-Admin/sosti/pesquisarsolicitacoes/formpesquisa/nSosti/' +
      propriedade_valor(EsostiSolicitacaoPropriedade::NUMERO_NOME)
  end

  def get_tracker_id
    default_tracker_id = Setting.plugin_trf1_esosti['tracker_id']
    unless default_tracker_id.nil?
      for tracker in trf1_sjap_project.project.trackers
        return default_tracker_id if tracker.id == default_tracker_id.to_i
      end
    end
    fail 'Projeto não possui trackers' if trf1_sjap_project.project.trackers.empty?
    trf1_sjap_project.project.trackers[0].id
  end
end
