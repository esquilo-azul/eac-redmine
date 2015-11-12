class FrequenciaRelatorio
  include ActiveModel::Model

  attr_accessor :funcionario_id, :ano, :mes

  validates :funcionario_id, :ano, :mes, presence: true

  def datas
    return nil unless valid?
    dias.collect { |d| build_dia(d) }
  end

  def funcionario
    Funcionario.find(funcionario_id)
  end

  private

  def dias
    1..mes_ultimo_dia
  end

  def data(dia)
    Date.civil(ano.to_i, mes.to_i, dia)
  end

  def mes_ultimo_dia
    data(-1).strftime('%d').to_i
  end

  def build_dia(dia)
    PontoCargaHoraria.build_dia(funcionario, data(dia))
  end
end
