class EsostiSolicitacao < ActiveRecord::Base
  NOME_SOLICITANTE_NOME = 'Nome do Solicitante'
  MATRICULA_NOME = 'Matricula'
  POR_ORDEM_NOME = 'Por ordem de'
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
    return false
  end
  
  def updates 
    EsostiUpdate.where(:esosti_solicitacao_id => id).order('index asc')
  end
  
  def propriedades 
    EsostiSolicitacaoPropriedade.where(:esosti_solicitacao_id => id)
  end
  
  def propriedade_valor(propriedade_nome)
    propriedade = EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: self.id, nome: propriedade_nome).first
    if propriedade
      return propriedade.valor
    else
      raise "Proprieade não encontrada (esosti_propriedade_id: #{self.id}, nome: #{propriedade_nome}"
    end
  end
  
  def has_propriedade(propriedade_nome)
    EsostiSolicitacaoPropriedade.where(esosti_solicitacao_id: self.id, nome: propriedade_nome).count > 0
  end

  def self.get_or_create(trf1_sjap_project, esosti_id)
    esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(esosti_id)
    if !esosti_solicitacao
      esosti_solicitacao = EsostiSolicitacao.new
      esosti_solicitacao.closed = false
      esosti_solicitacao.trf1_sjap_project_id = trf1_sjap_project.id
      esosti_solicitacao.esosti_id = esosti_id
      ModelUtils::save_or_raise(esosti_solicitacao)
    end
    esosti_solicitacao
  end
  
  def assert_usuario
    if has_propriedade(POR_ORDEM_NOME)
      usuario_rotulo = propriedade_valor(POR_ORDEM_NOME)
    else
      usuario_rotulo = "#{propriedade_valor(MATRICULA_NOME)} - #{propriedade_valor(NOME_SOLICITANTE_NOME)}"
    end
    EsostiUsuario.get_or_create(usuario_rotulo)
  end

  def assert_updates(raw_updates)
    novos = 0
    index = 0
    for raw_update in raw_updates
      novos += 1 if assert_update(index, raw_update)            
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
  
end
