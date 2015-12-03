class FrequenciaRelatorio
  include ActiveModel::Model

  attr_accessor :funcionario_id, :inicio_mes, :inicio_ano, :fim_mes, :fim_ano

  validates :funcionario_id, :inicio_mes, :inicio_ano, :fim_mes, :fim_ano, presence: true

  def folhas
    return nil unless valid?
    r = []
    funcionarios.each do |f|
      meses.each do |m|
        r << Folha.new(f, m[:ano], m[:mes])
      end
    end
    r
  end

  private

  def funcionarios
    Funcionario.where(id: funcionario_id).order(nome: :asc).all
  end

  def meses
    limites = [ano_mes_to_index(inicio_ano.to_i, inicio_mes.to_i),
               ano_mes_to_index(fim_ano.to_i, fim_mes.to_i)]
    (limites.min..limites.max).map { |v| index_to_ano_mes(v) }
  end

  def ano_mes_to_index(ano, mes)
    (ano - 1).to_i * 12 + (mes - 1).to_i
  end

  def index_to_ano_mes(index)
    { ano: (index / 12) + 1, mes: (index % 12) + 1 }
  end

  class Folha
    attr_reader :funcionario, :ano, :mes

    def initialize(funcionario, ano, mes)
      @funcionario = funcionario
      @ano = ano
      @mes = mes
    end

    def dias
      (1..mes_ultimo_dia).collect { |d| build_dia(d) }
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
end
