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
    "#{format_ponto_entrada_horario(i[:inicio])} - #{format_ponto_entrada_horario(i[:termino])}"
  end

  def format_ponto_entrada_horario(ponto_entrada)
    return '?' unless ponto_entrada
    format_time(ponto_entrada.data_hora, false)
  end
end
