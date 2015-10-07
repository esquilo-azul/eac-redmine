module FrequenciaRelatoriosHelper
  def format_dia(data)
    data[:data].strftime('%d')
  end

  def format_dia_semana(data)
    day_name(data[:data].strftime('%w').to_i)
  end

  def format_intervalos_executados(data)
    data[:intervalos_executados].map { |i| format_intervalo(i) }.join(' | ')
  end

  def format_intervalo(i)
    "#{format_ponto_entrada_horario(i.inicio)} - #{format_ponto_entrada_horario(i.termino)}"
  end

  def format_horas_executadas(data)
    sum = intervalos_duracao_soma(data)
    sum > 0 ? format_time_diff(sum) : ''
  end

  def format_horas_executadas_total(datas)
    sum = 0
    datas.each { |data| sum += intervalos_duracao_soma(data) }
    format_time_diff(sum)
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

  def intervalos_duracao_soma(data)
    sum = 0
    data[:intervalos_executados].each { |i| sum += i.duracao }
    sum
  end
end
