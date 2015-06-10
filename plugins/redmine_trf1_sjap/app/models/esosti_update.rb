# encoding: UTF-8

class EsostiUpdate < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :index, scope: :esosti_solicitacao_id    
  validates_presence_of :esosti_solicitacao_id, :index  
  belongs_to :esosti_solicitacao
  has_many :esosti_update_items

  def item_valor(item_nome)
    item = EsostiUpdateItem.where(esosti_update_id: self.id, nome: item_nome).first
    if item
      return item.valor
    else
      raise "Item não encontrado (esosti_update_id: #{self.id}, nome: #{item_nome}"
    end
  end

end
