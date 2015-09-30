class CefIdSolicitacaosController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :cef_id_solicitacao do |conf|
    conf.columns[:funcionario].form_ui = :select
    conf.list.columns.exclude :created_at
    conf.list.columns.exclude :updated_at
    conf.actions.exclude :update, :delete, :create
    conf.actions.swap :search, :field_search
    conf.field_search.columns = :funcionario, :data
  end

  def relatorio_gravacoes
    @funcionarios = Funcionario.order(nome: :asc, matricula: :asc)
  end
end
