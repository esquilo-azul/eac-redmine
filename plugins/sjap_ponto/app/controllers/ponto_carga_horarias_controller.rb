class PontoCargaHorariasController < ApplicationController
  include Sjap::RolesAuthorization

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('ponto_carga_horaria_read') }

  def index
    @ponto_carga_horarias = PontoCargaHoraria.order(data_inicial: :desc, data_final: :asc, created_at: :desc).all
  end

  def new
    @ponto_carga_horaria = PontoCargaHoraria.new
    build_funcionarios_list
  end

  def create
    @ponto_carga_horaria = PontoCargaHoraria.new(ponto_carga_horaria_params)
    if @ponto_carga_horaria.save
      redirect_to ponto_carga_horarias_url, notice: 'Carga horária foi salva com sucesso'
    else
      build_funcionarios_list
      render :new
    end
  end

  private

  def ponto_carga_horaria_params
    params.require(:ponto_carga_horaria).permit(
      :descricao, :data_inicial, :data_final,
      :minutos_continuo, :minutos_descontinuo,
      funcionarios_attributes: [:id, :funcionario, :funcionario_id, :_destroy]
    ).merge(autor: User.current)
  end

  def build_funcionarios_list
    @funcionarios_list = Funcionario.order(nome: :asc).all.collect { |p| [p.nome, p.id] }
  end
end
