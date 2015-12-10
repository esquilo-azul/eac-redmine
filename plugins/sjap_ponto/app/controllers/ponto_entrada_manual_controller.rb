class PontoEntradaManualController < ApplicationController
  layout 'trf1_sjap'
  include Sjap::RolesAuthorization

  before_filter { |c| c.require_role('ponto_entrada_create') }

  def new
    @ponto_entrada_manual = PontoEntradaManual.new
    now = @ponto_entrada_manual.time_zone.now
    @ponto_entrada_manual.ano = now.year
    @ponto_entrada_manual.mes = now.month
    @ponto_entrada_manual.dia = now.day
    @ponto_entrada_manual.hora = now.hour
    @ponto_entrada_manual.minuto = now.min
    ponto_entrada_manual_options
  end

  def create
    @ponto_entrada_manual = PontoEntradaManual.new(ponto_entrada_manual_params)
    if @ponto_entrada_manual.save
      redirect_to new_ponto_entrada_manual_path, notice: "Entrada de ponto \"#{@ponto_entrada_manual.ponto_entrada}\""\
        ' criada com sucesso.'
    else
      ponto_entrada_manual_options
      render :new
    end
  end

  private

  def ponto_entrada_manual_params
    { autor: User.current }.merge(params[:ponto_entrada_manual].permit(:motivo, :ano, :mes, :dia, :hora, :minuto, :funcionario_id))
  end

  def ponto_entrada_manual_options
    @anos = PontoEntradaManual.anos_list
    @meses = PontoEntradaManual.meses_list
    @dias = PontoEntradaManual.dias_list
    @horas = PontoEntradaManual.horas_list
    @minutos = PontoEntradaManual.minutos_list
  end
end
