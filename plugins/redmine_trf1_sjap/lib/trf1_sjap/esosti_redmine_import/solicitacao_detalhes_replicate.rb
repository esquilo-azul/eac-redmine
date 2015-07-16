# encoding: UTF-8

module Trf1Sjap
  class EsostiRedmineImport
    class SolicitacaoDetalhesReplicate

      attr_reader :result
      def initialize(esosti_solicitacao, propriedades, updates)
        raise 'updates.count <= 0' if updates.count <= 0
        raise 'propriedades.empty?' if propriedades.empty?
        raise "updates[0][:fase] != FASE_CADASTRO_DESCRICAO (#{esosti_solicitacao.esosti_id}, \"#{updates[0][:fase]}\")" if updates[0][:fase] != SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
        @result = [esosti_solicitacao.assert_propriedades(propriedades), esosti_solicitacao.assert_updates(updates)]
      end

    end
  end
end