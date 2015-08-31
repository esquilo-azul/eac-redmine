class PontoEntradasController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :ponto_entrada do |conf|
    conf.columns[:data_hora].form_ui = :datetime_picker
    conf.columns[:autor].form_ui = :select
    conf.columns[:funcionario].form_ui = :select
    conf.columns[:terminal].form_ui = :select
    conf.create.columns.exclude :autor, :terminal
    conf.actions.exclude :update, :delete
  end

  def before_create_save(record)
    record.operacao = PontoEntrada::OPERACAO_MANUAL
    record.autor = User.current
  end
end
