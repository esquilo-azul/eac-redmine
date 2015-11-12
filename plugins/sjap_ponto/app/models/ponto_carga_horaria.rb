class PontoCargaHoraria < ActiveRecord::Base
  belongs_to :autor, class_name: 'User'
  has_many :funcionarios, class_name: 'PontoCargaHorariaFuncionario', inverse_of: :ponto_carga_horaria
  has_one :cancelamento, class_name: 'PontoCargaHorariaCancelamento', inverse_of: :ponto_carga_horaria
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

  def to_s
    "#{descricao} / " + if data_final
                          "De #{data_inicial} ate #{data_final}"
                        else
                          "A partir de #{data_inicial}"
    end
  end

  def self.find_by_funcionario_and_data(funcionario, data)
    validos = ativo.where(['? >= data_inicial', data]).includes(:funcionarios).where(ponto_carga_horaria_funcionarios: { funcionario_id: funcionario.id })
    fechado = validos.where(['? <= data_final', data]).order(data_final: :asc).first
    return fechado if fechado
    validos.where(data_final: nil).order(data_inicial: :desc).first
  end

  def self.build_dia(funcionario, data)
    Dia.new(funcionario, data, find_by_funcionario_and_data(funcionario, data))
  end

  def self.ativo
    includes(:cancelamento).where(ponto_carga_horaria_cancelamentos: { id: nil })
  end

  class Dia
    include Trf1Sjap::SimpleCache

    attr_reader :funcionario, :data, :carga_horaria

    def initialize(funcionario, data, carga_horaria)
      @funcionario = funcionario
      @data = data
      @carga_horaria = carga_horaria
    end

    def horas_devidas
      return 0 unless carga_horaria
      return 0 if [0, 6].include?(data.wday)
      return carga_horaria.minutos_descontinuo * 60 if intervalos_executados.count > 1
      carga_horaria.minutos_continuo * 60
    end

    def intervalos_executados
      cache_value(__method__) do
        IntervaloBuilder.new(ponto_entradas).intervalos
      end
    end

    def horas_executadas
      cache_value(__method__) do
        sum = 0
        intervalos_executados.each { |i| sum += i.duracao }
        sum
      end
    end

    def horas_saldo
      horas_executadas - horas_devidas
    end

    private

    def ponto_entradas
      cache_value(__method__) do
        PontoEntrada.where(funcionario: funcionario, data_hora: data.beginning_of_day..data.end_of_day).order(data_hora: :asc)
      end
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
end
