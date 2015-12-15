class PontoTerminal < ActiveRecord::Base
  TIPOS = %w(
    SUPERFACIL
  )

  validates :descricao, presence: true
  validates :tipo, presence: true, inclusion: TIPOS
  validates :endereco, presence: true
  validates :usuario, presence: true
  validates :senha, presence: true
  validates :fuso_horario, presence: true, format: { with: /[\-\+]\d{2}\:\d{2}/ }

  def to_s
    descricao
  end

  def build_time(year, month, day, hour, minutes, seconds)
    Time.new(year, month, day, hour, minutes, seconds, fuso_horario)
  end

  def fuso_horario_offset
    fail '"fuso_horario" não definido' unless fuso_horario
    m = /([\-\+])(\d{2})\:(\d{2})/.match(fuso_horario)
    fail "Formato de fuso horário \"#{fuso_horario}\" não reconhecido" unless m
    (m[1] == '-' ? -1 : 1) * (m[2].to_f + m[3].to_f / 60)
  end

  private

  def time_zone
    tz = ActiveSupport::TimeZone[fuso_horario_offset]
    tz || fail("Zona não encontrada para offset \"#{fuso_horario_offset}\"")
  end
end
