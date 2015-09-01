class PontoEntradasController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :ponto_entrada do |conf|
    conf.columns[:data_hora].form_ui = :datetime_picker
    conf.columns[:autor].form_ui = :select
    conf.columns[:funcionario].form_ui = :select
    conf.columns[:terminal].form_ui = :select
    conf.columns[:motivo].required = true
    conf.actions.swap :search, :field_search
    conf.field_search.columns = :funcionario, :data_hora
    conf.create.columns.exclude :autor, :terminal, :metodo
    conf.actions.exclude :update, :delete
  end

  def create_authorized?
    UserRole.user_has_role('ponto_entrada_create')
  end

  def list_authorized?
    UserRole.user_has_role('ponto_entrada_read')
  end

  def before_create_save(record)
    record.metodo = 'MANUAL'
    record.autor = User.current
  end
end
