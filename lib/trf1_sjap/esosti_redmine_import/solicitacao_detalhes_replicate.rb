# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class SolicitacaoDetalhesReplicate

      attr_reader :result
      def initialize(esosti_solicitacao, updates)
        raise 'updates.count <= 0' if updates.count <= 0
        raise "updates[0][:fase] != FASE_CADASTRO_DESCRICAO (#{esosti_solicitacao.esosti_id}, \"#{updates[0][:fase]}\")" if updates[0][:fase] != SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
        index = 0
        @result = 0
        for update in updates
          if import_solicitacao_update(esosti_solicitacao, update, index)
            @result += 1
          end
          index += 1
        end
      end

      private

      def import_solicitacao_update(esosti_solicitacao, update, index)
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
end