class EsostiSolicitacaoPropriedade < ActiveRecord::Base
  NUMERO_NOME='Solicitação Nº'
  unloadable
  validates_presence_of :esosti_solicitacao_id, :nome
  validates_uniqueness_of :nome, scope: :esosti_solicitacao_id
  validates :valor, exclusion: { in: [nil] }
  belongs_to :esosti_solicitacao
end
