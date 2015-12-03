class PontoCargaHorariasController < ApplicationController
  module Create
    def new
      @ponto_carga_horaria = PontoCargaHoraria.new
      build_funcionarios_list
    end

    def create
      @ponto_carga_horaria = ponto_carga_horaria_submited
      if @ponto_carga_horaria.save
        redirect_to ponto_carga_horarias_url, notice: 'Carga horária foi salva com sucesso'
      else
        build_funcionarios_list
        render :new
      end
    end

    private

    def ponto_carga_horaria_submited
      pch = PontoCargaHoraria.new(
        params.require(:ponto_carga_horaria).permit(
          :descricao, :data_inicial, :data_final,
          :minutos_continuo, :minutos_descontinuo
        ).merge(autor: User.current)
      )
      funcionarios_id = params[:ponto_carga_horaria][:funcionario_id]
      if funcionarios_id.is_a?(Array)
        funcionarios_id.each do |id|
          pch.funcionarios << PontoCargaHorariaFuncionario.new(funcionario_id: id)
        end
      end
      pch
    end

    def build_funcionarios_list
      @funcionarios_list = Funcionario.order(nome: :asc).all.collect { |p| [p.nome, p.id] }
    end
  end
end
