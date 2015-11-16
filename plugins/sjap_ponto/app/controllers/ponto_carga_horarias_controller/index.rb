class PontoCargaHorariasController < ApplicationController
  module Index
    def index
      @funcionario = nil
      @funcionario = Funcionario.find(params['funcionario']) unless params['funcionario'].blank?
      @ponto_carga_horarias = index_query.order(data_inicial: :desc, data_final: :asc,
                                                created_at: :desc).all
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
end
