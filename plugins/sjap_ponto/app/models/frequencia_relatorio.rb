class FrequenciaRelatorio
  include ActiveModel::Model

  attr_accessor :funcionario_id, :ano, :mes

  validates :funcionario_id, :ano, :mes, presence: true

  def datas
    return nil unless valid?
    dias.collect { |d| { data: data(d), intervalos_executados: intervalos_executados(d) } }
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

  def intervalos_executados(d)
    IntervaloBuilder.new(ponto_entradas(data(d))).intervalos
  end

  def ponto_entradas(data)
    PontoEntrada.where(funcionario_id: funcionario_id, data_hora: data.beginning_of_day..data.end_of_day).order(data_hora: :asc)
  end

  class Intervalo
    attr_accessor :inicio, :termino

    def initialize(inicio)
      @inicio = inicio
      @termino = nil
    end

    def duracao
      @termino ? @termino.data_hora - @inicio.data_hora : 0
    end
  end

  class IntervaloBuilder
    attr_reader :intervalos

    def initialize(ponto_entradas)
      @intervalos = []
      @current = nil
      ponto_entradas.each { |pe| add_ponto_entrada(pe) }
    end

    private

    def current
      @intervalos[-1]
    end

    def add_ponto_entrada(pe)
      if !current || (current && current.termino)
        @intervalos << Intervalo.new(pe)
      else
        current.termino = pe
      end
    end
  end
end
