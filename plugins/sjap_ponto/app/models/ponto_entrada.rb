class PontoEntrada < ActiveRecord::Base
  OPERACAO_TERMINAL = 1
  OPERACAO_MANUAL = 2

  attr_accessor :operacao

  belongs_to :funcionario
  belongs_to :terminal, class_name: 'PontoTerminal'
  belongs_to :autor, class_name: 'User'

  validates :data_hora, presence: true
  validates :funcionario, presence: true
  validates :operacao, presence: true, inclusion: [OPERACAO_TERMINAL, OPERACAO_MANUAL]
  validates :motivo, presence: true, length: { minimum: 3 }, if: Proc.new{|u| u.operacao == OPERACAO_MANUAL }
  validate :autor_usuario_logado

  def autor_usuario_logado
    return unless self.operacao == OPERACAO_MANUAL
    if !User.current || self.autor != User.current
      errors.add(:autor, 'Autor não é o usuário logado.')
    end
  end 
end
