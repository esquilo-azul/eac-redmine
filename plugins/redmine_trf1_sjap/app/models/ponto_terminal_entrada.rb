class PontoTerminalEntrada < ActiveRecord::Base
  belongs_to :ponto_terminal

  validates :ponto_terminal, presence: true
  validates :tipo, presence: true, inclusion: %w(ponto)
  validates :chave, presence: true, uniqueness: { scope: [:ponto_terminal, :tipo] }

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
