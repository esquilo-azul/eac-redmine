class FrequenciaRelatorio
  include ActiveModel::Model

  attr_accessor :funcionario_id, :ano, :mes

  validates :funcionario_id, :ano, :mes, presence: true

  def folhas
    return nil unless valid?
    funcionario_id.map { |id| Folha.new(Funcionario.find(id), ano, mes) }
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
