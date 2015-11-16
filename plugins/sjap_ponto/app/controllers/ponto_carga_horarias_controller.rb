class PontoCargaHorariasController < ApplicationController
  include Sjap::RolesAuthorization

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('ponto_carga_horaria_read') }

  def index
    @funcionario = nil
    @funcionario = Funcionario.find(params['funcionario']) unless params['funcionario'].blank?
    @ponto_carga_horarias = index_query.order(data_inicial: :desc, data_final: :asc,
                                              created_at: :desc).all
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

  def cancelamento
    @ponto_carga_horaria_cancelamento = PontoCargaHorariaCancelamento.new
    @ponto_carga_horaria_cancelamento.ponto_carga_horaria = PontoCargaHoraria.find(params[:id])
  end

  def cancelamento_post
    @ponto_carga_horaria_cancelamento = PontoCargaHorariaCancelamento.new(
      ponto_carga_horaria_cancelamento_params)
    @ponto_carga_horaria_cancelamento.ponto_carga_horaria = PontoCargaHoraria.find(params[:id])
    if @ponto_carga_horaria_cancelamento.save
      redirect_to ponto_carga_horarias_url, notice: 'Carga horária foi cancelada com sucesso'
    else
      render :cancelamento
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

  def ponto_carga_horaria_cancelamento_params
    params.require(:ponto_carga_horaria_cancelamento).permit(:motivo).merge(autor: User.current)
  end

  def build_funcionarios_list
    @funcionarios_list = Funcionario.order(nome: :asc).all.collect { |p| [p.nome, p.id] }
  end

  def index_query
    query = PontoCargaHoraria
    if @funcionario
      query = query.includes(:funcionarios).where(ponto_carga_horaria_funcionarios:
          { funcionario_id: @funcionario.id })
    end
    query
  end
end
