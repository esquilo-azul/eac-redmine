class PontoTerminal < ActiveRecord::Base
  TIPOS = %w(
    SUPERFACIL
  )

  validates :descricao, presence: true
  validates :tipo, presence: true, inclusion: TIPOS
  validates :endereco, presence: true
  validates :usuario, presence: true
  validates :senha, presence: true
  validates :fuso_horario, presence: true, format: { with: /[\-\+]\d{2}\:\d{2}/ }

  def to_s
    descricao
  end
end
