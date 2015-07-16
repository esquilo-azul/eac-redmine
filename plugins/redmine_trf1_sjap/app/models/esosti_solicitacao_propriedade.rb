class EsostiSolicitacaoPropriedade < ActiveRecord::Base
  MATRICULA_NOME = 'Matricula'
  NOME_SOLICITANTE_NOME = 'Nome do Solicitante'
  NUMERO_NOME='Solicitação Nº'
  POR_ORDEM_NOME = 'Por ordem de'
  DESCRICAO_NOME='Descrição'
  unloadable
  validates_presence_of :esosti_solicitacao_id, :nome
  validates_uniqueness_of :nome, scope: :esosti_solicitacao_id
  validates :valor, exclusion: { in: [nil] }
  belongs_to :esosti_solicitacao
end
