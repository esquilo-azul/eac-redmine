class PontoCargaHoraria < ActiveRecord::Base
  belongs_to :autor, class_name: 'User'
  has_many :funcionarios, class_name: 'PontoCargaHorariaFuncionario', inverse_of: :ponto_carga_horaria
  accepts_nested_attributes_for :funcionarios, reject_if: :all_blank, allow_destroy: true
  validates :descricao, :data_inicial, :minutos_continuo, :minutos_descontinuo, :autor,
            presence: true
  validates :minutos_continuo, :minutos_descontinuo, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0, less_than: 60 * 20
  }
  validate :data_final_greater_than_data_inicial, :funcionarios_minimum

  def data_final_greater_than_data_inicial
    return unless data_inicial && data_final && data_final < data_inicial
    errors.add(:data_final, 'Data final deve ser igual ou posterior à data inicial')
  end

  def funcionarios_minimum
    return unless funcionarios.empty?
    errors.add(:funcionarios, 'Necessario ao menos um funcionário')
  end
end
