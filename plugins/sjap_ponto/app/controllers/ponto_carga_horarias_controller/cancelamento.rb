class PontoCargaHorariasController < ApplicationController
  module Cancelamento
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

    def ponto_carga_horaria_cancelamento_params
      params.require(:ponto_carga_horaria_cancelamento).permit(:motivo).merge(autor: User.current)
    end
  end
end
