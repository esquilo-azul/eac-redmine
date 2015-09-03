class PontoEntrada < ActiveRecord::Base
  belongs_to :funcionario
  belongs_to :terminal, class_name: 'PontoTerminal'
  belongs_to :autor, class_name: 'User'
  has_one :cancelamento, class_name: 'PontoCancelamento', inverse_of: :ponto_entrada

  validates :data_hora, presence: true
  validates :funcionario, presence: true
  validates :metodo, presence: true, inclusion: %w(MANUAL TERMINAL)
  validates :motivo, presence: true, length: { minimum: 3 }, if: proc { |u| u.metodo == 'MANUAL' }
  validates :terminal, presence: true, if: proc { |u| u.metodo == 'TERMINAL' }
  validate :autor_usuario_logado

  def autor_usuario_logado
    if metodo == 'MANUAL'
      return if User.current && autor == User.current
      errors.add(:autor, 'Autor não é o usuário logado.')
    elsif metodo == 'TERMINAL'
      return unless autor
      errors.add(:autor, 'Autor deve ser nulo.')
    end
  end
end
