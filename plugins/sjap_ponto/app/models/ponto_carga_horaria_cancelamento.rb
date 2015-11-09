class PontoCargaHorariaCancelamento < ActiveRecord::Base
  belongs_to :ponto_carga_horaria
  belongs_to :autor, class_name: 'User'
  validates :ponto_carga_horaria, presence: true, uniqueness: true
  validates :autor, presence: true, uniqueness: { scope: [:ponto_carga_horaria] }
  validates :motivo, presence: true, length: { minimum: 3 }
end
