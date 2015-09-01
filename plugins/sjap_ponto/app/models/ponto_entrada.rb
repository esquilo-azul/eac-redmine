class PontoEntrada < ActiveRecord::Base
  belongs_to :funcionario
  belongs_to :terminal, class_name: 'PontoTerminal'
  belongs_to :autor, class_name: 'User'

  validates :data_hora, presence: true
  validates :funcionario, presence: true
  validates :metodo, presence: true, inclusion: ['MANUAL', 'TERMINAL']
  validates :motivo, presence: true, length: { minimum: 3 }, if: Proc.new{|u| u.metodo == 'MANUAL' }
  validate :autor_usuario_logado

  def autor_usuario_logado
    return unless self.metodo == 'MANUAL'
    if !User.current || self.autor != User.current
      errors.add(:autor, 'Autor não é o usuário logado.')
    end
  end 
end
