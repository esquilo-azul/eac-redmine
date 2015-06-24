class EsostiFasesController < ApplicationController
  before_action :set_esosti_fase, only: [:show, :edit, :update, :destroy]

  # GET /esosti_fases
  def index
    @esosti_fases = EsostiFase.all.order('rotulo')
  end

  # GET /esosti_fases/new
  def new
    @esosti_fase = EsostiFase.new
  end

  # GET /esosti_fases/1/edit
  def edit
  end

  # POST /esosti_fases
  def create
    @esosti_fase = EsostiFase.new(esosti_fase_params)
    if @esosti_fase.save
      redirect_to esosti_fases_url, notice: 'Esosti fase was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /esosti_fases/1
  def update
    if @esosti_fase.update(esosti_fase_params)
      redirect_to esosti_fases_url, notice: 'Esosti fase was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /esosti_fases/1
  def destroy
    @esosti_fase.destroy
    redirect_to esosti_fases_url, notice: 'Esosti fase was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_esosti_fase
      @esosti_fase = EsostiFase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def esosti_fase_params
      params.require(:esosti_fase).permit(:rotulo, :issue_status_id)
    end
end
