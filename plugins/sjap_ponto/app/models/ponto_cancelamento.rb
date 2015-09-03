class PontoCancelamento < ActiveRecord::Base
  belongs_to :ponto_entrada, inverse_of: :cancelamento
  belongs_to :autor, class_name: 'User'

  validates :ponto_entrada, presence: true
  validates :autor, presence: true
  validates :motivo, presence: true, length: { minimum: 3 }
  validate :autor_usuario_logado
  validate :ponto_entrada_cancelamento_unico

  def autor_usuario_logado
    return if User.current && autor == User.current
    errors.add(:autor, 'Autor não é o usuário logado.')
  end

  def ponto_entrada_cancelamento_unico
    return unless PontoCancelamento.where(ponto_entrada: ponto_entrada).any?
    errors.add(:ponto_entrada, 'Esta entrada de ponto já foi cancelada anteriormente.')
  end
end
