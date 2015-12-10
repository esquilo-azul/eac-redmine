class PontoEntradaManual
  include ActiveModel::Model
  include Trf1Sjap::ModelExtensions

  attr_accessor :autor, :motivo, :ano, :mes, :dia, :hora, :minuto, :funcionario_id

  def save
    r = ponto_entrada.save
    unless r
      fetch_record_errors(ponto_entrada)
      errors.add(:dia, 'Data inválida') unless data_hora
    end
    r
  end

  def ponto_entrada
    @ponto_entrada ||= PontoEntrada.new(ponto_entrada_params)
  end

  def self.anos_list
    min_date = PontoEntrada.minimum(:data_hora)
    min_year = min_date ? min_date.year : 2000
    max_year = Time.zone.now.year
    range_list(min_year, max_year)
  end

  def self.meses_list
    range_list(1, 12)
  end

  def self.dias_list
    range_list(1, 31)
  end

  def self.horas_list
    range_list(0, 23)
  end

  def self.minutos_list
    range_list(0, 59)
  end

  def self.range_list(min, max)
    r = {}
    (min..max).each { |i| r[i] = i }
    r
  end

  def time_zone
    fail "Setting.plugin_sjap_ponto['ponto_entrada_manual_time_zone'] não definido" unless Setting.plugin_sjap_ponto['ponto_entrada_manual_time_zone']
    tz = ActiveSupport::TimeZone[Setting.plugin_sjap_ponto['ponto_entrada_manual_time_zone']]
    fail "Time zone não encontrado para #{Setting.plugin_sjap_ponto['ponto_entrada_manual_time_zone']}" unless tz
    tz
  end

  private

  def ponto_entrada_params
    { metodo: 'MANUAL', autor: autor, motivo: motivo, funcionario_id: funcionario_id,
      data_hora: data_hora }
  end

  def data_hora
    time_zone.local(ano.to_i, mes.to_i, dia.to_i, hora.to_i, minuto.to_i)
  end
end
