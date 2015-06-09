# encoding: UTF-8

module Trf1Sjap  
  class EsostiRedmineImport
    
    def self.import_caixa_secao_atendimento(trf1_sjap_project, solicitacoes)
      novas = 0
      for solicitacao in solicitacoes
        if import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
          novas += 1
        end
      end
      return novas
    end
    
    def self.import_solicitacao_detalhes(esosti_solicitacao, updates)
      index = 0
      novas = 0
      for update in updates
        if import_solicitacao_update(esosti_solicitacao, update, index)
          novas += 1
        end
      end      
      return novas
    end
    
    private
    
    def self.import_caixa_secao_atendimento_solicitacao(trf1_sjap_project, solicitacao)
      esosti_solicitacao = EsostiSolicitacao.find_by_esosti_id(solicitacao[:id])
      if !esosti_solicitacao 
        esosti_solicitacao = EsostiSolicitacao.new
        esosti_solicitacao.closed = false
        esosti_solicitacao.trf1_sjap_project_id = trf1_sjap_project.id
        esosti_solicitacao.esosti_id = solicitacao[:id]
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
   
  end
end