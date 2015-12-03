class FrequenciaRelatoriosController < ApplicationController
  include Sjap::RolesAuthorization
  helper :funcionarios

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('frequencia_relatorio_read') }

  def index
    if request.post?
      @frequencia_relatorio = FrequenciaRelatorio.new(frequencia_relatorio_params)
      @folhas = @frequencia_relatorio.folhas
    else
      @frequencia_relatorio = FrequenciaRelatorio.new(default_frequencia_relatorio_params)
      @folhas = nil
    end
    @meses = meses
    @anos = anos
  end

  private

  def frequencia_relatorio_params
    params.require(:frequencia_relatorio).permit(:inicio_ano, :inicio_mes, :fim_ano, :fim_mes,
                                                 funcionario_id: [])
  end

  def default_frequencia_relatorio_params
    now = Time.zone.now
    { inicio_ano: now.year, inicio_mes: now.month, fim_ano: now.year, fim_mes: now.month }
  end

  def meses
    (1..12).collect { |m| [m.to_s, m] }
  end

  def anos
    (ano_min..ano_max).collect { |a| [a.to_s, a] }
  end

  def ano_max
    Time.zone.now.strftime('%Y').to_i
  end

  def ano_min
    pe = PontoEntrada.order(data_hora: :asc).first
    pe ? pe.data_hora.strftime('%Y').to_i : ano_max
  end
end
