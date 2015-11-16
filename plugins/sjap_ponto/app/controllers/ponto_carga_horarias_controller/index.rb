class PontoCargaHorariasController < ApplicationController
  module Index
    extend ActiveSupport::Concern

    included do
      include SortHelper
      helper :sort
    end

    def index
      sort_init 'data_inicial'
      sort_update %w(data_inicial data_final descricao minutos_continuo minutos_descontinuo)
      @funcionario = nil
      @funcionario = Funcionario.find(params['funcionario']) unless params['funcionario'].blank?
      @limit = per_page_option
      s = scope
      @rows_count = s.count
      @rows_pages = Redmine::Pagination::Paginator.new @rows_count, @limit, params['page']
      @offset = @rows_pages.offset
      @rows = s.order(sort_clause).limit(@limit).offset(@offset).to_a
    end

    def scope
      s = PontoCargaHoraria
      if @funcionario
        s = s.includes(:funcionarios).where(ponto_carga_horaria_funcionarios:
            { funcionario_id: @funcionario.id })
      end
      s
    end
  end
end
