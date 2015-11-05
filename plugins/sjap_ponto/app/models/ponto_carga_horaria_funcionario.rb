class PontoCargaHorariaFuncionario < ActiveRecord::Base
  belongs_to :ponto_carga_horaria, inverse_of: :funcionarios
  belongs_to :funcionario
  validates :ponto_carga_horaria, presence: true, uniqueness: { scope: [:funcionario] }
  validates :funcionario, presence: true, uniqueness: { scope: [:ponto_carga_horaria] }
end
