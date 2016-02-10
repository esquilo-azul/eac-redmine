class PontoTerminalEntrada < ActiveRecord::Base
  belongs_to :ponto_terminal
  belongs_to :exportado, polymorphic: true

  validates :ponto_terminal, presence: true
  validates :tipo, presence: true, inclusion: %w(ponto funcionario)
  validates :chave, presence: true, uniqueness: { scope: [:ponto_terminal, :tipo] }
  validates :exportado_id, uniqueness: { scope: [:exportado_type] }, if: :'exportado_ponto?'
  validates :exportado_type, uniqueness: { scope: [:exportado_id] }, if: :'exportado_ponto?'

  def exportado_ponto?
    exportado_type == PontoEntrada.name
  end

  def self.replicate(ponto_terminal, tipo, chave)
    entrada = where(ponto_terminal: ponto_terminal, tipo: tipo, chave: chave.strip).first
    if entrada
      false
    else
      entrada = new(ponto_terminal: ponto_terminal, tipo: tipo, chave: chave.strip)
      Trf1Sjap::ModelUtils.save_or_raise(entrada)
      true
    end
  end
end
