module FrequenciaRelatoriosHelper
  def format_dia(dia)
    dia.data.strftime('%d')
  end

  def format_dia_semana(dia)
    day_name(dia.data.strftime('%w').to_i)
  end

  def format_intervalos_executados(dia)
    dia.intervalos_executados.map { |i| format_intervalo(i) }.join(' | ')
  end

  def format_horario_descricao(dia)
    return dia.carga_horaria.descricao if dia.carga_horaria
    '-'
  end

  def format_horas_devidas(dia)
    dia.horas_devidas > 0 ? format_time_diff(dia.horas_devidas) : '-'
  end

  def format_horas_devidas_total(dias)
    sum = 0
    dias.each { |dia| sum += dia.horas_devidas }
    format_time_diff(sum)
  end

  def format_horas_executadas(dia)
    dia.horas_executadas > 0 ? format_time_diff(dia.horas_executadas) : ''
  end

  def format_horas_executadas_total(dias)
    sum = 0
    dias.each { |dia| sum += dia.horas_executadas }
    format_time_diff(sum)
  end

  def format_horas_saldo(dia)
    format_time_diff(dia.horas_saldo)
  end

  def format_horas_saldo_total(dias)
    sum = 0
    dias.each { |dia| sum += dia.horas_saldo }
    format_time_diff(sum)
  end

  private

  def format_intervalo(i)
    "#{format_ponto_entrada_horario(i.inicio)} - #{format_ponto_entrada_horario(i.termino)}"
  end

  def format_ponto_entrada_horario(ponto_entrada)
    return '?' unless ponto_entrada
    format_time(ponto_entrada.data_hora, false)
  end

  def format_time_diff(diff)
    hours = (diff / 3600).floor
    minutes = (((diff - hours * 3600) / 60).floor).to_s.rjust(2, '0')
    "#{hours}:#{minutes}"
  end
end
