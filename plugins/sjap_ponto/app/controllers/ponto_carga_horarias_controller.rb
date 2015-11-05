class PontoCargaHorariasController < ApplicationController
  include Sjap::RolesAuthorization

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('ponto_carga_horaria_read') }

  def index
    @ponto_carga_horarias = PontoCargaHoraria.order(data_inicial: :desc, data_final: :asc, created_at: :desc).all
  end

  def new
    @ponto_carga_horaria = PontoCargaHoraria.new
  end

  def create
    @ponto_carga_horaria = PontoCargaHoraria.new(ponto_carga_horaria_params)
    if @ponto_carga_horaria.save
      redirect_to ponto_carga_horarias_url, notice: 'Carga horária foi salva com sucesso'
    else
      render :new
    end
  end

  private

  def ponto_carga_horaria_params
    p = params.require(:ponto_carga_horaria).permit(:descricao, :data_inicial, :data_final, :minutos_continuo, :minutos_descontinuo)
    p[:autor] = User.current
    p
  end
end
