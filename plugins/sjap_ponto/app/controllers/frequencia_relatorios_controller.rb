class FrequenciaRelatoriosController < ApplicationController
  include Sjap::RolesAuthorization

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('frequencia_relatorio_read') }

  def index
    if request.post?
      @frequencia_relatorio = FrequenciaRelatorio.new(frequencia_relatorio_params)
      @datas = @frequencia_relatorio.datas
    else
      @frequencia_relatorio = FrequenciaRelatorio.new
      @datas = nil
    end
    @meses = meses
    @anos = anos
    @funcionarios = funcionarios
  end

  private

  def frequencia_relatorio_params
    params.require(:frequencia_relatorio).permit(:funcionario_id, :ano, :mes)
  end

  def funcionarios
    Funcionario.order(nome: :asc).all.collect { |p| [p.nome, p.id] }
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
