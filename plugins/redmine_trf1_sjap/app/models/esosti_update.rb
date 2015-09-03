# encoding: UTF-8

class EsostiUpdate < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :index, scope: :esosti_solicitacao_id
  validates_presence_of :esosti_solicitacao_id, :index
  belongs_to :esosti_solicitacao
  has_many :esosti_update_items

  def item_valor(item_nome)
    item = EsostiUpdateItem.where(esosti_update_id: id, nome: item_nome).first
    if item
      return item.valor
    else
      fail "Item não encontrado (esosti_update_id: #{id}, nome: #{item_nome}"
    end
  end

  def fase
    esosti_fase = EsostiFase.find_by_rotulo(fase_rotulo)
    unless esosti_fase
      esosti_fase = EsostiFase.new(rotulo: fase_rotulo)
      Trf1Sjap::ModelUtils.save_or_raise(esosti_fase)
    end
    esosti_fase
  end

  def fase_rotulo
    Trf1Sjap::SolicitacaoDetalhes.parse_fase(item_valor('Fase'))[0]
  end

  def to_s
    "#{esosti_solicitacao_id}/#{index}"
  end
end
